/* @(#) qwrite.c 1.4 98/07/09 13:40:48 */
/* Copyright (c) 1993 Association of Universities for Research 
 * in Astronomy. All rights reserved. Produced under National   
 * Aeronautics and Space Administration Contract No. NAS5-26555.
 */
/* qwrite.c Write binary data
 *
 * Programmer: R. White     Date: 11 March 1991
 */
#include <stdio.h>
#include <stdlib.h>

extern void qwrite(FILE *outfile, char *a, int n);
extern int mywrite(FILE *file, char buffer[], int n);

extern void writeshort(FILE *outfile, int a)
{
int i;
unsigned char b[2];

    /* Write integer A one byte at a time to outfile.
     *
     * This is portable from Vax to Sun since it eliminates the
     * need for byte-swapping.
     */
    for (i=1; i>=0; i--) {
        b[i] = a & 0x000000ff;
        a >>= 8;
    }
    qwrite(outfile, (char *) b,2);
}

extern void writeint(FILE *outfile, int a)
{
int i;
unsigned char b[4];

    /* Write integer A one byte at a time to outfile.
     *
     * This is portable from Vax to Sun since it eliminates the
     * need for byte-swapping.
     */
    for (i=3; i>=0; i--) {
        b[i] = a & 0x000000ff;
        a >>= 8;
    }
    qwrite(outfile, (char *) b,4);
}

extern void qwrite(FILE *outfile, char *a, int n)
{
    if(mywrite(outfile, a, n) != n) {
        perror("qwrite");
        exit(-1);
    }
}

/*
 * write n bytes from buffer into file
 * returns number of bytes written (=n) if successful, <=0 if not
 */
extern int mywrite(FILE *file, char buffer[], int n)
{
    if (fwrite(buffer, 1, n, file) != n) {
        fprintf(stderr, "mywrite: error in write\n");
        return (-1);
    }
    return (n);
}
