#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>


int main(int argc, char *argv[]) {
    int n;

    scanf("%d", &n);

    int pid = (int) getpid();
    int rc = fork();
    if (rc < 0) {
        fprintf(stderr, "fork failed\n");
        exit(1);
    } else if (rc == 0) {
        for (int i = 1; i <= n; i++)
            printf("C %d %d\n", (int) getpid(), i);
    } else {
        for (int i=n+1; i<=2*n; i++)
            printf("P %d %d\n", pid, i);
    }

    return 0;
}