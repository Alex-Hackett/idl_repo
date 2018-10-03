CC = cc
CFLAGS = -O
LDFLAGS =

O=.o

OBJS = fitspass$O makefits$O pdecomp$O qwrite$O	\
fitsread$O pair_decode$O put_data$O swap_bytes$O \
get_data$O pair_encode$O qread$O timing$O

.c$O:
	$(CC) -c $(DEFS) $(CFLAGS) $<

default: pdecomp

clean:
	rm -f *$O pdecomp a.out core

pdecomp: $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

