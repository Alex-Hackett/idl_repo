/* @(#) put_data.c 1.4 98/07/09 13:40:47 */
/* Copyright (c) 1998 Association of Universities for Research 
 * in Astronomy. All rights reserved. Produced under National   
 * Aeronautics and Space Administration Contract No. NAS5-26555.
 */
/* put_data.c   Write short image data to outfile as I*2, swapping bytes
 *              if requested.  Note that data is swapped in place if swapping
 *              is necessary.
 *
 * Programmer: R. White     Date: 19 June 1998
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int  test_swap(/* void */);
extern void swap_bytes(unsigned char a[], int n);

static void put_raw(FILE *outfile, short a[], int n, int swap);

extern void put_data(FILE *outfile, short a[], int n, char *format)
{
    if (strcmp(format,"raw") == 0 || strcmp(format,"hhh") == 0) {
        put_raw(outfile, a, n, 0);
    } else if (strcmp(format,"net") == 0 || strcmp(format,"fits") == 0) {
        put_raw(outfile, a, n, 1);
    } else {
        fprintf(stderr, "put_data: unknown format %s\n", format);
        exit(-1);
    }
}

#define BLOCKSIZE 512

static void put_raw(FILE *outfile, short a[], int n, int swap)
{
int i, nblock;
int tswap;

    /*
     * see if byte-swapping will be needed
     */
    if (swap) {
        tswap = test_swap();
    } else {
        tswap = 0;
    }
    /*
     * swap & write BLOCKSIZE pixels at a time to minimize paging/cache problems
     */
    nblock = BLOCKSIZE;
    for (i=0; i<n; i += BLOCKSIZE) {
        /* last block may be shorter */
        if (n-i < BLOCKSIZE) nblock = n-i;
        if (tswap) swap_bytes((unsigned char *) &a[i],nblock*sizeof(short));
        if(fwrite(&a[i], sizeof(short), nblock, outfile) != nblock) {
            perror("put_data");
            exit(-1);
        }
    }
}

/* Write zero padding bytes to get to multiple of 2880 bytes
 * n is the number of I*2 pixels that have already been written
 */

extern void put_fits_pad(FILE *outfile, int n)
{
short *sa;

    /*
     * add zeroes to get up to multiple of 2880 bytes
     * number of padding short ints to write is between 0 and 1439
     */
    n = 1439 - ((n-1) % 1440);
    if (n > 0) {
        /*
         * allocate a block of zeros
         */
        sa = (short *) calloc(n , sizeof(short));
        if (sa == (short *) NULL) {
            fprintf(stderr, "insufficient memory\n");
            exit(-1);
        }
        if(fwrite(sa, 1, n*sizeof(short), outfile) != n*sizeof(short)) {
            perror("put_data");
            exit(-1);
        }
        free(sa);
    }
}
