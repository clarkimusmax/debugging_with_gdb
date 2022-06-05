#include <stdio.h>
#include <string.h>

int main (void)
{
	size_t i;
	char *str = "This program is not very good.";

	/* ...or efficient */
	for (i = 0; i < strlen(str); i++) {
		printf("%c", str[i]);
	}
	puts("");

	/* BOOM! */
	((void(*)(void))NULL)();

	return 0;
}
