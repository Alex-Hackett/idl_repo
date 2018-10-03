/* @(#) pair_decode.c 1.2 98/07/09 13:40:52 */
/* Copyright (c) 1998 Association of Universities for Research 
 * in Astronomy. All rights reserved. Produced under National   
 * Aeronautics and Space Administration Contract No. NAS5-26555.
 */
/* pair_decode.c
 *
 * Do pixel-pair decoding for an array.  This procedure decodes the compressed
 * image data from the HST Advanced Camera.
 *
 * Input parameters:
 *
 * buffer       Pointer to the start of the input buffer, from which the
 *              compressed data are read.
 * endbuf       Pointer to one past the end of the input buffer.
 * T1           Threshold parameter used in encoding algorithm (standard value
 *              is 224.)
 * n            Number of pixel values to decode.  n must be even.  For the
 *              HST Advanced Camera, n will normally be 2048, since the image
 *              gets compressed in blocks of 2048 pixels.
 *
 * Output parameters:
 *
 * a            Output array (short[n]) where decoded pixel values will be
 *              stored.
 * ndecode      Number of pixels actually decoded.  On a normal return this
 *              will be equal to n.  If the end of buffer is reached before
 *              decoding n pixels, ndecode will be smaller than n.  In that
 *              case the values of the remaining output array values
 *              (a[ndecode]...a[n-1]) are undefined.
 * return-value The function return value is a pointer to the next element to
 *              be read from the buffer.  If the end of buffer is reached this
 *              will be equal to endbuf.  (buffer == endbuf is not an error
 *              indicator, though -- check ndecode!=n to see if there was an
 *              error.)
 *
 * This is not highly optimized for speed (it doesn't run onboard.)  This
 * version ought to be fast enough for our purposes.
 *
 * I have not worried about the byte ordering (big endian vs little
 * endian) in the input and output data streams.  This may need to change
 * depending on the exact order of bytes produced by the ACS onboard
 * computer.  If a change is required it will not be large; I think
 * that at most it will be necessary to swap byte pairs in the input
 * buffer at the beginning of this procedure.
 *
 * Programmer: R. White     Date: 21 January 1998
 */
#include <stdio.h>
#include <stdlib.h>

extern unsigned char *pair_decode(
  unsigned char *buffer,          /* Input buffer                            */
  unsigned char *endbuf,          /* Pointer to one past end of input buffer */
  int            T1,              /* Coding threshold                        */
  int            n,               /* Size of array                           */
  short a[],                      /* Output array [n]                        */
  int            *ndecode)        /* Number of pixels decoded (returned)     */
{
unsigned char flags, fbit;
long     vlast, diff1, diff2, vcomb, triangle;
long     i, j, ndirect=0, ncomb1=0, ncomb2=0;
long     T2, OFFSET2;

    if ((n & 1) != 0) {
        fprintf(stderr,
            "pair_decode: row length %d must be multiple of 2\n", n);
        exit(-1);
    }

    /*
     * Threshold values used in the pair coding.
     *
     * T1 is threshold for 1-byte code (standard value I'm using is 224)
     * T2 is second threshold for 2-byte code
     * OFFSET2 is amount to add to combined value to fill in top bits and
     *    subtract offset T1
     */
    T2 = ( ((long) 256 - T1)<<8 ) + T1 ;
    OFFSET2 = 65536 - T2 ;

    /*
     * Loop over pixel pairs, reading a new set of flags for every 16 pixels.
     *
     * If the end of buffer is reached we break out of the loop and
     * use the current value of i to indicate how many pixels
     * were successfully decoded.
     */
    fbit = 1;
    vlast = 0;
    for (i = 0; i < n; i += 2) {
        fbit >>= 1;
        if (fbit == 0) {
            /*
             * Flags is a 1-byte set of flags for each group of 8 pixel pairs.
             * Corresponding bit is zero if compressed differences were used
             * for the pair, 1 if uncompressed raw pixel values were used.
             */
            fbit = 128;
            if (buffer >= endbuf) break;
            flags = *buffer++;
        }
        if ((flags & fbit) != 0) {

            /* direct coding of pixel values if flag bit is set */

            if (buffer >= endbuf) break;
            a[i]  = ((short) *buffer++) << 8;
            if (buffer >= endbuf) break;
            a[i] +=  (short) *buffer++;

            if (buffer >= endbuf) {
                /* Increment i since we did get a[i] pixel value */
                i++;
                break;
            }
            a[i+1]  = ((short) *buffer++) << 8;
            if (buffer >= endbuf) {
                /* Increment i since we did get a[i] pixel value.
                 * Note that we also got the top half of a[i+1] -- that
                 * information is not being returned (it is very unlikely to be
                 * useful.)
                 */
                i++;
                break;
            }
            a[i+1] +=  (short) *buffer++;

            ndirect++;

        } else {

            /* compressed code for pair of pixels if flag bit not set */

            if (buffer >= endbuf) break;
            vcomb = *buffer++;
            if (vcomb >= T1) {
                vcomb <<= 8;
                if (buffer >= endbuf) break;
                vcomb  += (*buffer++) - OFFSET2;
                ncomb2++;
            } else {
                ncomb1++;
            }
            /*
             * Here's the slowest part.  Just step through the triangle numbers
             * to figure out which interval this code is in.  The n-th triangle
             * number is n*(n+1)/2.
             *
             * I'm sure there is a faster way to do this search, but I haven't
             * bothered looking for it.
             */
            for (j=1, triangle=1; vcomb >= triangle; triangle += (++j) ) ;

            diff2 = vcomb - triangle + j;
            diff1 = j-1 - diff2;

            /* Undo difference mapping
             * Given difference mapped to non-negative values, map back
             * to +/- values.  Results are stored back in diff1 & 2.
             */
            if ((diff1 & 1) == 0) {
                diff1 = diff1>>1;
            } else {
                diff1 = ~(diff1>>1);
            }
            if ((diff2 & 1) == 0) {
                diff2 = diff2>>1;
            } else {
                diff2 = ~(diff2>>1);
            }
            a[i]   = (short) (vlast + diff1);
            a[i+1] = (short) (a[i]  + diff2);
        }
        vlast = a[i+1];
    }
    /* set ndecode to number of pixels decoded */ 
    *ndecode = i;
    return (buffer);
}
