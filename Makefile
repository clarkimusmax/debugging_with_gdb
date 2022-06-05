CC = gcc
CFLAGS = -ggdb -O0 -Wall -Wextra

.PHONY: all
all: hello crash

hello: hello.o
	$(CC) $(CFLAGS) -o $@ $<

crash: crash.o
	$(CC) $(CFLAGS) -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $<

.PHONY: clean
clean:
	-rm hello crash *.o
