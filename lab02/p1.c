#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    int ppid = (int) getpid();
    int rc = fork();

    if (rc < 0) {
        fprintf(stderr, "fork failed\n");
        exit(1);
    } else if (rc == 0) {
        printf("Child : My process ID is:%d\n",(int) getpid());
        printf("Child : The parent process ID is:%d\n", ppid);
    } else {
        printf("Parent : My process ID: %d\n", (int) getpid());
        printf("Parent : The child process if:%d\n", rc);
    }
}
