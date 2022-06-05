#include <stdio.h>
#include <unistd.h>

int main (void)
{
	/* Print hello */
	puts("Hello, World!");

	/* Sleep forever */
	for (;;) {
	       sleep(1000);
	}

	return 0;
}
