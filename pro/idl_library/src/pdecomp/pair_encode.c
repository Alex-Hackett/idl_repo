/* @(#) pair_encode.c 1.2 98/07/09 13:40:51 */
/* Copyright (c) 1998 Association of Universities for Research 
 * in Astronomy. All rights reserved. Produced under National   
 * Aeronautics and Space Administration Contract No. NAS5-26555.
 */
/* pair_encode.c    Do pixel-pair encoding for an array.  Writes codes
 *                  to outbuf.  Returns pointer to next element to
 *                  be written in outbuf.  Row length must be multiple
 *                  of 16.
 *
 * New version that uses faster differencing and mapping
 *
 * Programmer: R. White     Date: 7 August 1997
 */
#include <stdio.h>
#include <stdlib.h>

/*
 * Threshold values used in the pair coding.
 *
 * T1 is threshold for 1-byte code
 * T2 is second threshold for 2-byte code
 * OFFSET2 is amount to add to combined value to fill in top bits and
 *    subtract offset T1
 *
 * #define T1 ((long) 224)
 * #define T2 ( ( ((long) 256 - T1)<<8 ) + T1 )
 * #define OFFSET2 (65536 - T2)
 *
 * DIFFTHRESH is maximum pixel difference value that can possibly
 * avoid direct coding.  Larger values must necessarily have pixel
 * values coded directly.  Need to check this to avoid integer
 * overflows for very large differences.  A faster approach (in
 * assembly language) would be to check directly for integer overflows
 * in the vcomb*(vcomb+1) calculation in diffCode, but that test is not
 * possible in C.
 *
 * Here is the general definition of DIFFTHRESH for other
 * thresholds.  Another approach would be just to define
 * DIFFTHRESH as a large value (e.g. 16000) and not change it
 * with T2.  That would be a bit slower but would be simpler.
 *
 * DIFFTHRESH = ((long) sqrt(0.25+2*T2) - 0.5)
 */
#define T1      224
#define T2      8416
#define OFFSET2 57120

#define DIFFTHRESH 129

/* putPair macro:
 *
 * Write pair of 16-bit values (not differences) to output buffer and set flag
 * bit using fbit.
 *
 * Perhaps there is a more efficient way of writing the two bytes of each
 * short value to the output buffer than using the shifts.
 */

#define putPair(outbuf, v1, v2, fbit) {                                      \
                                        *outbuf++ = (unsigned char) (v1>>8); \
                                        *outbuf++ = (unsigned char) (v1);    \
                                        *outbuf++ = (unsigned char) (v2>>8); \
                                        *outbuf++ = (unsigned char) (v2);    \
                                        flags    |= fbit;                    \
                                      }

/* diffCompute macro:
 *
 * Given pixel *p, and last pixel value vlast:
 * (1) save this pixel value in vnext
 * (2) increment pointer *p
 * (3) compute diff = difference from last pixel
 * (4) map difference to positive integer (negative values get mapped to
 *     odd integers, positive values to even integers, zero mapped to zero)
 *
 * This gets executed once for each pixel in the row.  It is probably
 * the most time-consuming part of the computation.
 */
#define diffCompute(p, vlast, vnext, diff) {                        \
                                    vnext = (long) *p++;            \
                                    diff  = vnext - vlast;          \
                                    diff  = (diff < 0) ?            \
                                      ~(diff<<1) : (diff<<1);       \
                                 }

/* diffCode macro:
 *
 * Given pair of pixel differences diff1, diff2 and pair of pixel
 * values v1, v2, code the pixel pair in 1 or 2 bytes (depending
 * on values) or code pixel values directly in 4 bytes (2 bytes each)
 * and set flag bit to indicate direct coding.
 *
 * This gets executed once for each pair of pixels.  A large majority of
 * the pixel pairs take first branch of the if (vcomb < T1), so the
 * optimization of the other branches is not as important.
 *
 * Note that vcomb and diff1 could share the same register.  If register
 * space is tight, probably the values saved in v1,v2 could be read again
 * from memory (in *(p-2), *(p-1)) without slowing things down much.
 */

#define diffCode(diff1, diff2, v1, v2, fbit) {                              \
                                    vcomb = diff1+diff2;                    \
                                    vcomb = diff2+((vcomb*(vcomb+1)) >> 1); \
                                    if (vcomb < T1) {                       \
                                        *outbuf++ = (unsigned char) vcomb;  \
                                    } else if (vcomb < T2) {                \
                                        vcomb += OFFSET2;                   \
                                        *outbuf++ = (unsigned char) (vcomb>>8); \
                                        *outbuf++ = (unsigned char) vcomb;  \
                                    } else {                                \
                                        putPair(outbuf, v1, v2, fbit);      \
                                    }                                       \
                                 }

/* pairCode macro:
 *
 * do coding of a pair of pixel values starting at *p
 * last pixel value must be in vlast
 * pointer p gets incremented twice and last pixel value is left in vlast
 */
#define pairCode(p, vlast, vnext, fbit) {                                       \
                            diffCompute(p, vlast, vnext, diff1);                \
                            if (diff1 > DIFFTHRESH) {                           \
                                vlast = (long) *p++;                            \
                                putPair(outbuf, vnext, vlast, fbit);            \
                            } else {                                            \
                                diffCompute(p, vnext, vlast, diff2);            \
                                if (diff2 > DIFFTHRESH) {                       \
                                    putPair(outbuf, vnext, vlast, fbit);        \
                                } else {                                        \
                                    diffCode(diff1, diff2, vnext, vlast, fbit); \
                                }                                               \
                            }                                                   \
                          }

/****************************************************/

extern unsigned char *pair_encode(
  unsigned char *outbuf,     /* Output buffer      */
  short a[],                 /* input array [n]    */
  int            n)          /* size of array      */
{
register unsigned char flags, *flagloc;
register short *p, *pend;
register long            v1, v2, diff1, diff2, vcomb;

    if (n & 15 != 0) {
        fprintf(stderr,
            "pair_encode: row length %d must be multiple of 16\n", n);
        exit(-1);
    }
    /*
     * Loop over pixels in blocks of 16
     */
    p = a;
    pend = &a[n];
    v2 = 0;
    while (p < pend) {
        /*
         * flagloc points to 1-byte set of flags for each group of 8 pixel pairs
         * corresponding bit is zero for compressed differences for the pair,
         * 1 for uncompressed raw pixel values
         */
        flagloc = outbuf++;
        flags   = 0;

        pairCode(p, v2, v1, 128);
        pairCode(p, v2, v1,  64);
        pairCode(p, v2, v1,  32);
        pairCode(p, v2, v1,  16);
        pairCode(p, v2, v1,   8);
        pairCode(p, v2, v1,   4);
        pairCode(p, v2, v1,   2);
        pairCode(p, v2, v1,   1);

        *flagloc = flags;
    }
    return (outbuf);
}
