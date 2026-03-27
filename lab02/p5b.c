#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<string.h>
#include<time.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char *argv[]){
    
    int rc = fork();

    if (rc < 0) {
        printf("fork failed\n");
        exit(1);
    } else if (rc == 0) {
        printf("Child : My process ID is: %d\n", getpid());
        printf("Child : The parent process ID is: %d\n\n", getppid());

        printf("Child : Check child process state\n\n");

        printf("Child : Press any key to continue\n");
        getchar();
        printf("Child : Check child process state again\n");

    } else {
        printf("Parent : My process ID is: %d\n", getpid());
        printf("Parent : The child process ID is: %d\n", rc);

        sleep(60);
        printf("Parent reaping child\n");
        int rc_wait = wait(NULL);

    }

    return 0;
}