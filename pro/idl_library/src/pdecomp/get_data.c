/* @(#) get_data.c 1.4 98/07/09 13:40:45 */
/* get_data.c   Read I*2 image data from infile and return as short
 *
 * Format may be raw, net, or fits.  For FITS input format, header
 * lines get written to outfile.  For raw or net format, the image
 * size nx,ny must be passed as input; for FITS format they are
 * returned as output.
 *
 * If byte-swapping is needed, it is done in place and the input
 * array is modified.
 *
 * Programmer: R. White     Date: 18 June 1998
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int  test_swap(/* void */);
extern void swap_bytes(unsigned char a[], int n);

static void get_raw(FILE *infile, char *inname, short **a, int nx, int ny, int swap);
static void get_fits(FILE *infile, char *inname, FILE *outfile, short **a, int *nx, int *ny);
extern void fitsread(FILE *infile, char *inname, FILE *outfile, int *nx, int *ny,
    int passthru, int padded, int nlterm);

extern void get_data(FILE *infile, char *inname, FILE *outfile,
    short **a, int *nx, int *ny, char *format)
{
    if (strcmp(format,"raw") == 0) {
        get_raw(infile, inname, a, *nx, *ny, 0);
    } else if (strcmp(format,"net") == 0) {
        get_raw(infile, inname, a, *nx, *ny, 1);
    } else if (strcmp(format,"fits") == 0) {
        get_fits(infile, inname, outfile, a, nx, ny);
    } else {
        fprintf(stderr, "get_data: unknown format %s\n", format);
        exit(-1);
    }
    fclose(infile);
}

static void get_raw(FILE *infile, char *inname, short **a, int nx, int ny, int swap)
{
int i, j, nread;
int tswap;
short *pa;

    /*
     * read a row at a time to minimize page faulting problems
     */
    *a = (short *) malloc(nx * ny * sizeof(short));
    if (*a == (short *) NULL) {
        fprintf(stderr, "insufficient memory\n");
        exit(-1);
    }
    /*
     * see if byte swapping will be needed
     */
    if (swap) {
        tswap = test_swap();
    } else {
        tswap = 0;
    }
    /*
     * read rows
     */
    pa = *a;
    for (i=0; i<nx; i++) {
        /* might require several reads to get ny elements under VMS */
        j = 0;
        while (j < ny) {
            nread = fread(&pa[j+i*ny], sizeof(short), ny-j, infile);
            if (nread < 0) {
                fprintf(stderr,
                    "error reading I*2 image (size %d %d) from %s\n",
                    nx, ny, inname);
                exit(-1);
            }
            j += nread;
        }
        /*
         * swap if necessary
         */
        if (tswap) swap_bytes((unsigned char *) &pa[i*ny],ny*sizeof(short));
    }
}

static void get_fits(FILE *infile, char *inname, FILE *outfile, short **a, int *nx, int *ny)
{
    /*
     * read fits header
     */
    if (outfile != (FILE *) NULL) {
        /*
         * 1: pass lines through to outfile
         * 1: header is multiple of 2880 bytes
         * 0: lines are not terminated by newline
         */
        fitsread(infile, inname, outfile, nx, ny, 1, 1, 0);
    } else {
        /*
         * no output file, don't pass lines through to outfile
         */
        fitsread(infile, inname, outfile, nx, ny, 0, 1, 0);
    }
    /*
     * read raw pixel data with byte swapping
     */
    get_raw(infile, inname, a, *nx, *ny, 1);
}
