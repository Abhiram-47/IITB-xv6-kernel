/*
* This is a classic problem known as "resuable barrier synchronization"
* or "two-phase barrier synchronization". The solution is discussed in
* the famous book "Little Book of Semaphores". However, I referred to the
* solution directly from the stackoverflow :)
* https://stackoverflow.com/questions/47522174/reusable-barrier-implementation-using-posix-semaphores
*/


#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

struct barrier{
    // ******************************
    // WPTHREAD -- START
    // ******************************
    // ADD VARIABLES YOU MIGHT NEED HERE

    int n;
    int count;
    int sem_mutex;
    int sem_turnstile;
    int sem_turnstile2;

    // ******************************
    // WPTHREAD -- END
    // ******************************
};

struct barrier bar;

void barrier_init(struct barrier* bar, int num_threads){
    // ******************************
    // WPTHREAD -- START
    // ******************************

    bar->n = num_threads;
    bar->count = 0;
    bar->sem_mutex = semaphore_init(1);
    bar->sem_turnstile = semaphore_init(0);
    bar->sem_turnstile2 = semaphore_init(0);
  

    // ******************************
    // WPTHREAD -- END
    // ******************************
}

void phase1_barrier(struct barrier* bar) {

    semaphore_down(bar->sem_mutex);
    if (++bar->count == bar->n) {
        for (int i = 0; i < bar->n; i++)
            semaphore_up(bar->sem_turnstile);
    }
    semaphore_up(bar->sem_mutex);
    semaphore_down(bar->sem_turnstile);
}

void phase2_barrier(struct barrier* bar) {

    semaphore_down(bar->sem_mutex);
    if (--bar->count == 0) {
        for (int i = 0; i < bar->n; i++)
            semaphore_up(bar->sem_turnstile2);
    }
    semaphore_up(bar->sem_mutex);
    semaphore_down(bar->sem_turnstile2);
}

void barrier_place(struct barrier* bar){
    // ******************************
    // WPTHREAD -- START
    // ******************************

    phase1_barrier(bar);
    phase2_barrier(bar);

    // ******************************
    // WPTHREAD -- END
    // ******************************

}

void work(int *thread_num){

    for(int i=0;i<3;i++){

        barrier_place(&bar);

        printf(1,"LOOP %d | Section 1 of code | Thread Number: %d\n",i,*thread_num);

        barrier_place(&bar);

        printf(1,"LOOP %d | Section 2 of code | Thread Number: %d\n",i,*thread_num);

    }

    exit();
}

int main(int argc, char *argv[]) {

    int N = 5;
    int ind[N];
    for(int i=0;i<N;i++)
        ind[i]=i;

    barrier_init(&bar,N);

    for(int i=0;i<N;i++) {
        create_thread(work, &ind[i]);
    }

    for(int i=0;i<N;i++) {
        join();
    }

    printf(1, "All threads joined, code completed\n");
    exit();
}