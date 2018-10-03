/* @(#) timing.c 1.4 98/07/09 13:40:50 */
/*
 * Timing routines
 *   void   set_start_time()         Initial call to start timing
 *   double get_delta_time()         Get time since last call in seconds.
 *   void   print_time    (char *label)
 *   void   init_cum_time (int number)
 *   void   start_cum_time(int number)
 *   void   end_cum_time  (int number)
 *   void   print_cum_time(int number, char *label)
 *   void   push_cum_time (int number)
 *   void   pop_cum_time  (int number)
 *
 * These calls work on Unix and the Mac (as far as I have tested), so they
 * should be pretty generic.
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static double tstart = -1.0;
static double tlast = -1.0;

#define TIME (clock()/((double) CLOCKS_PER_SEC))

extern void set_start_time()
{
    tstart = TIME;
    tlast = tstart;
}

extern double get_delta_time()
{
double tnow, delta;

    tnow = TIME;
    if (tstart == -1.0) {
        tstart = tnow;
        tlast = tnow;
    }
    delta = tnow - tlast;
    tlast = tnow;
    return (delta);
}

extern void print_time(char *label)
{
double tnow;

    tnow = TIME;
    if (tstart == -1.0) {
        tstart = tnow;
        tlast = tnow;
    }
    if (label != (char *) NULL) {
        fprintf(stderr, "%7.3f %7.3f s: %s\n", tnow-tlast, tnow-tstart,
            label);
    } else {
        fprintf(stderr, "%7.3f %7.3f s: %s\n", tnow-tlast, tnow-tstart,
            "no label");
    }
    tlast = tnow;
}

#define NCT 50
static double cumtime[NCT];
static double startcumtime[NCT];

extern void init_cum_time(int number)
{
    if (number>=NCT) {
        fprintf(stderr, "init_cum_time: error, number %d >= NCT %d\n",
            number, NCT);
        exit(-1);
    }
    cumtime[number] = 0.0;
}

extern void start_cum_time(int number)
{
    if (number>=NCT) {
        fprintf(stderr, "start_cum_time: error, number %d >= NCT %d\n",
            number, NCT);
        exit(-1);
    }
    startcumtime[number] = TIME;
}

extern void end_cum_time(int number)
{
double tnow;

    if (number>=NCT) {
        fprintf(stderr, "end_cum_time: error, number %d >= NCT %d\n",
            number, NCT);
        exit(-1);
    }
    tnow = TIME;
    cumtime[number] = cumtime[number] + tnow - startcumtime[number];
}

extern void print_cum_time(int number, char *label)
{
    if (number>=NCT) {
        fprintf(stderr, "print_cum_time: error, number %d >= NCT %d\n",
            number, NCT);
        exit(-1);
    }
    if (label != (char *) NULL) {
        fprintf(stderr, "%7.3f     cum s: %s\n", cumtime[number],
            label);
    } else {
        fprintf(stderr, "%7.3f     cum s: %s\n", cumtime[number],
            "no label");
    }
}

#define NSTACK 50
int stack[NSTACK];
int top = -1;

extern void push_cum_time(int number)
{
double tnow;

    tnow = TIME;
    if (top >= 0) {
        cumtime[stack[top]] = cumtime[stack[top]]+tnow-startcumtime[stack[top]];
    }
    if (++top < NSTACK) {
        stack[top] = number;
        startcumtime[number] = tnow;
    } else {
        fprintf(stderr, "push_cum_time: stack overflow\n");
        exit(-1);
    }
}

extern void pop_cum_time(int number)
{
double tnow;

    tnow = TIME;
    if (top < 0) {
        fprintf(stderr, "pop_cum_time: top of stack\n");
        exit(-1);
    } else {
        if (stack[top] != number) {
            fprintf(stderr, "pop_cum_time: top = %d, number = %d\n",
                stack[top], number);
        }
        cumtime[number] = cumtime[number]+tnow-startcumtime[number];
        if (--top >= 0) startcumtime[stack[top]] = tnow;
    }
}

