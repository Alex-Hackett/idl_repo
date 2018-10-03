/* @(#) qread.c 1.4 98/07/09 13:40:48 */
/* Copyright (c) 1998 Association of Universities for Research 
 * in Astronomy. All rights reserved. Produced under National   
 * Aeronautics and Space Administration Contract No. NAS5-26555.
 */
/* qread.c  Read binary data
 *
 * Programmer: R. White     Date: 19 June 1998
 */
#include <stdio.h>
#include <stdlib.h>

extern void qread(FILE *infile, char *a, int n);
extern int myread(FILE *file, char buffer[], int n);

extern int readshort(FILE *infile)
{
int a,i;
unsigned char b[2];

    /* Read integer A one byte at a time from infile.
     *
     * This is portable from Vax to Sun since it eliminates the
     * need for byte-swapping.
     */
    qread(infile,(char *) b, 2);
    a = b[0];
    for (i=1; i<2; i++) a = (a<<8) + b[i];
    return(a);
}

extern int readint(FILE *infile)
{
int a,i;
unsigned char b[4];

    /* Read integer A one byte at a time from infile.
     *
     * This is portable from Vax to Sun since it eliminates the
     * need for byte-swapping.
     */
    qread(infile,(char *) b, 4);
    a = b[0];
    for (i=1; i<4; i++) a = (a<<8) + b[i];
    return(a);
}

extern void qread(FILE *infile, char *a, int n)
{
    if(myread(infile, a, n) != n) {
        perror("qread");
        exit(-1);
    }
}

/*
 * read n bytes from file into buffer
 * returns number of bytes read (=n) if successful, <=0 if not
 *
 * This version is for VMS C: each read may return
 * fewer than n bytes, so multiple reads may be needed
 * to fill the buffer.
 *
 * I think this is unnecessary for Sun Unix, but it won't hurt
 * either, so I'll leave it in.
 */
extern int myread(FILE *file, char buffer[], int n)
{
int nread, total;

    total = 0;
    while ( (nread = fread(&buffer[total], 1, n-total, file)) > 0) {
        total += nread;
        if (total==n) return(total);
    }
    /* end-of-file or error occurred if we got to here */
    return(nread);
}
