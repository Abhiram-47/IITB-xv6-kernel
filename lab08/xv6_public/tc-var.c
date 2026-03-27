#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int VAR = 0;

void increment(int *thread_rank) {
    int tmp = VAR;
    sleep(10);
    tmp++;
    sleep(10);
    VAR = tmp;
    // printf(1, "Am I being called...? whoami: %d\n", getpid());       TESTING-2
    exit();
}

int main(int argc, char *argv[]) {

    int N = 20;
    printf(1, "Calling Process Print VAR value: %d, N: %d\n", VAR, N);

    int ind[N];
    for(int i=0;i<N;i++)
        ind[i]=i;

    for(int i=0;i<N;i++) {
        create_thread(increment, &ind[i]);
    }

    for(int i=0;i<N;i++) {
        join();
    }

    printf(1, "All threads joined, VAR value: %d\n", VAR);
    // sleep(1000);     TESTING-1
    exit();
}