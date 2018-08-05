#include <stdio.h>

void a();
void b();

void main( int argc, char **argv )
{
	printf("Calling function a():\n");
	a();
	printf("Calling function b():\n");
	b();
	printf("That's all, folks!\n");
}
