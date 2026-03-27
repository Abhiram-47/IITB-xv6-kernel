#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<time.h>
#include<string.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[]){
    
    printf("Print statement before exec\n");
    
    // Do exec here
    if (argc != 2) {
        printf("Usage: %s <command>\n", argv[0]);
        exit(1);
    }

    char *cmd = (char *)malloc(strlen("./") + strlen(argv[1]) + 1);
    if (cmd == NULL) {
        printf("Memory allocation failed\n");
        exit(1);
    }
    strcpy(cmd, "./");
    strcat(cmd, argv[1]);

    char *myargs[2];
    myargs[0] = strdup("./");
    strcat(myargs[0], argv[1]);
    myargs[1] = NULL;

    execvp(cmd, myargs);


    printf("Print statement after exec. This should never print\n");
    
    
    return 0;
}