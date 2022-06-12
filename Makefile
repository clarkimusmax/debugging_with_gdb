# Set the c compiler to gcc
CC = gcc

# Include debugging sybmols, don't optimize, display all warning, display even more warning, treat warnings as errors
CFLAGS = -ggdb -O0 -Wall -Wextra -Werror

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
