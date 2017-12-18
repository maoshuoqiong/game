#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>  
int main(int argc ,char *argv[])
{
    char arg[300]="/usr/local/landlord/test/simp.sh";   
    system(arg);
    printf(arg);
    printf("\ndone message in program\n");
    
    return 1;
    
}
