#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) 
{
 char *addr;
       addr = getenv(argv[1]);
       printf("%s is stored at address %p\n", argv[1], addr);
 return 0;
 
}

