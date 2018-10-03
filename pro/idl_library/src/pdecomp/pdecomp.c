/* @(#) pdecomp.c 1.3 98/07/09 13:40:46 */
/* Copyright (c) 1998 Association of Universities for Research 
 * in Astronomy. All rights reserved. Produced under National   
 * Aeronautics and Space Administration Contract No. NAS5-26555.
 */
/* pdecomp.c    Decompress image file that was compressed using pcomp.
 *
 * This version of the program can produce output in 3 formats:
 *
 * (1) raw: I*2 pixel values with bytes in machine-dependent order,
 *          i.e. no byte swapping is done on output.  Image size may
 *          be specified with the -r and -c parameters.
 *
 * (2) net: I*2 pixel values with bytes with bytes in "network" order:
 *          high byte first, then low byte for each I*2 pixel.  Byte-swapping
 *          is done on output if needed.  Note that this is the same as
 *          raw format on some machines (e.g. Suns) but is different on
 *          others (e.g. VAXes).  Files in net format can be transferred
 *          from one machine to another without modification, but files
 *          in raw format cannot.
 *
 * (3) fits: FITS format image.  Header gives image size.  Bytes are
 *          in network order.
 *
 * The compressed input file may have two different formats, which are
 * recognized automatically by the program.  If the compressed file was
 * produced from a FITS input file, then the compressed file includes the
 * (uncompressed) FITS header at the start of the file, followed by the
 * compressed image data.  Otherwise the compressed input file contains
 * only the compressed image data.
 *
 * If the compressed file has a FITS header, then the default output format
 * is fits.  Otherwise the default output format is raw.
 *
 * Programmer: R. White     Date: 9 July 1998
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int  optind;
char *optarg;

int  verbose;
static char  *format;

extern unsigned char *pair_decode(unsigned char *buffer, unsigned char *endbuf,
    int T1, int n, short a[], int *ndecode);
extern void put_data(FILE *outfile, short *a, int n, char *format);
extern void put_fits_pad(FILE *outfile, int n);

static void usage(int argc, char *argv[]);
static void get_args(int argc, char *argv[]);
static void read_header(FILE *infile, FILE *outfile,
    int *outblock, int *nx, int *ny, char **format);

main (int argc, char *argv[])
{
unsigned char *buffer, *endbuf, *bufused;
short *a;
int nx, ny, outblock, thisblock, i, j;
int ntotal, noverflow, maxblock, ndecode;
/* fixed algorithm parameters:
 * inblock = number of pixels in each coding block
 * T1 = threshold used in pair coding
 */
int inblock = 2048, T1 = 224;

    /*
     * Get command line arguments
     */
    get_args(argc, argv);
    /*
     * Read compressed data header and write FITS header to
     * output file (if desired)
     */
    read_header(stdin, stdout, &outblock, &nx, &ny, &format);
    /*
     * allocate memory for array and buffer
     */
    a = (short *) malloc(inblock*sizeof(unsigned short));
    buffer = (unsigned char *) malloc(outblock);
    if (a == (short *) NULL || buffer == (unsigned char *) NULL) {
        fprintf(stderr, "rdecomp: insufficient memory\n");
        exit(-1);
    }
    endbuf = buffer + outblock;
    /*
     * Read from stdin and decode, writing pixel values to a.
     */
    ntotal = 0;
    noverflow = 0;
    maxblock = 0;
    thisblock = inblock;
    for (i=0; i<nx*ny; i += inblock) {
        ntotal++;
        /* read the block of data */
        if (fread(buffer, 1, outblock, stdin) != outblock) {
            fprintf(stderr, "pdecomp: error reading block %d from input\n", ntotal);
        }
        /* last block may have fewer pixels */
        if (nx*ny-i < inblock) thisblock = nx*ny-i;

        bufused = pair_decode(buffer,endbuf,T1,thisblock,a,&ndecode);
        if (bufused-buffer > maxblock) maxblock = bufused-buffer;

        /* fill with zeros if this block overflowed */
        if (ndecode < thisblock) {
            noverflow++;
            for (j=ndecode; j<thisblock; j++) a[j] = 0;
        }
        /*
         * Write data (possibly with byte-swapping)
         */
        put_data(stdout, (short *) a, thisblock, format);
    }
    /* write bytes to pad to multiple of 2880 if FITS format */
    if (strcmp(format,"fits") == 0) put_fits_pad(stdout, nx*ny);

    free(a);
    free(buffer);
    if (verbose) {
        fprintf(stderr,
            "Image size (%d,%d)  Output in %s format\n",
            ny,nx,format);
        fprintf(stderr, "Maximum compressed block size %d bytes\n", maxblock);
        if (noverflow>0) {
            fprintf(stderr, "*** %d of %d blocks overflowed\n", noverflow, ntotal);
        }
    }
    return(0);
}

static void usage(int argc, char *argv[])
{
    fprintf(stderr,
        "Usage: %s [-v] [-o raw|net|fits]\n",
        argv[0]);
    exit(-1);
}

/* GET COMMAND LINE ARGUMENTS */

static void get_args(int argc, char *argv[])
{
int c;

    /*
     * default values
     */
    verbose = 0;
    format = "";
    /*
     * get options
     */
    while ((c = getopt(argc,argv,"vo:")) != -1) {
        switch (c) {
        case 'v':
            /*
             * verbose flag -v
             */
            verbose = 1;
            break;
        case 'o':
            /*
             * -o <format> = raw, net, or fits
             */
            format = optarg;
            if (strcmp(format,"raw")  != 0 &&
                strcmp(format,"net")  != 0 &&
                strcmp(format,"fits") != 0) {
                fprintf(stderr, "Illegal input format %s\n", format);
                usage(argc,argv);
            }
            break;
        case '?':
            usage(argc,argv);
        }
    }
    /*
     * make sure there aren't any trailing parameters being ignored
     */
    if (optind < argc) {
        fprintf(stderr, "Too many parameters: %s ...\n", argv[optind]);
        usage(argc,argv);
    }
}

/*
 * Read header info for this image.
 * Note that if image is in FITS format, the FITS header precedes this data;
 * it is copied to the output file.
 *
 * Parameters:
 *  infile      input file
 *  outfile     output file (NULL for none)
 *  outblock    block size (returned)
 *  nx,ny       size of output array (returned)
 *  format      output file format (changed if empty string)
 */

/* "magic" value indicating Pair coding */
static char code_magic[2] = { (char)0xFE, (char)0xEF };

extern void qread(FILE *infile, char *c, int n);
extern void fitspass(FILE *infile, int passthru, FILE *outfile);
extern void makefits(FILE *outfile, int nx, int ny, int bitpix, char *datatype);
extern int  myread(FILE *infile, char *line, int n);
extern int  readint(FILE *infile);

static void read_header(FILE *infile, FILE *outfile,
    int *outblock, int *nx, int *ny, char **format)
{
int newfits = 0;
char tmagic[2], line[81];

    /*
     * File starts either with special 2-byte magic code or with
     * FITS keyword "SIMPLE  ="
     */
    qread(infile, tmagic, sizeof(tmagic));
    /*
     * Check for FITS
     */
    if (strncmp(tmagic,"SI",2)==0) {
        /*
         * read rest of line and make sure the whole keyword is correct
         */
        strncpy(line,"SI",2);
        if ((myread(infile, &line[2], 78) != 78) || 
            (strncmp(line, "SIMPLE  =", 9) != 0) ) {
            fprintf(stderr, "bad file format\n");
            exit(-1);
        }
        /*
         * set output format to default "fits" if it is empty
         */
        if ((*format)[0] == '\0') *format = "fits";
        /*
         * if fits output format and outfile != NULL, write this line to
         * outfile and then copy rest of FITS header; else just read past
         * FITS header.
         */
        if (strcmp(*format, "fits") == 0 && outfile != (FILE *) NULL) {
            if (fwrite(line,1,80,outfile) != 80) {
                perror("stdout");
                fprintf(stderr, "decode: error writing output file\n");
                exit(-1);
            }
            fitspass(infile,1,outfile);
        } else {
            fitspass(infile,0,outfile);
        }
        /*
         * now read the first two characters again -- this time they
         * MUST be the magic code!
         */
        qread(infile, tmagic, sizeof(tmagic));
    } else {
        /*
         * set default format to raw if it is not specified
         */
        if((*format)[0] == '\0') *format = "raw";
        /*
         * if input format is not FITS but output format is FITS, set
         * a flag so we generate a FITS header once we know how big
         * the image must be.
         */
        if (strcmp(*format, "fits") == 0) newfits = 1;
    }
    /*
     * check for correct magic code value
     */
    if (memcmp(tmagic,code_magic,sizeof(code_magic)) != 0) {
        fprintf(stderr, "bad file format\n");
        exit(-1);
    }

    /*
     * read the parameters from the header
     */
    *outblock = readint(infile);    /* output block size for each input block   */
    *nx = readint(infile);          /* x size of image                          */
    *ny = readint(infile);          /* y size of image                          */

    /*
     * write the new fits header to outfile if needed
     */
    if (newfits && (outfile != (FILE *) NULL)) {
        makefits(outfile,*nx,*ny,16,"INTEGER*2");
    }
}
