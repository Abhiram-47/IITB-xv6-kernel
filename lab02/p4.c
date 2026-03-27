#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char* argv[]) {
    int fd[2];
    //char buffer[11];
    int buffer[1];
    pipe(fd);

    printf("Process A : Input value of x : ");
    int num; scanf("%d", &num);
    int rc=fork();

    
    if (rc==0) {
        printf("Process B : Input value of y : ");
        int num2; scanf("%d", &num2);
        //char str[11];
        int str[1]={num2};
        //sprintf(str, "%d", num2);
        // printf("str: %s\n", str);
        write(fd[1], str, 4);
    } else {
        int rc_wait=wait(NULL);
        read(fd[0], buffer, 4);
        // printf("%s\n", buffer);
        num = num + buffer[0];
        printf("Process A: Result after addition : %d", num);
    }
}
