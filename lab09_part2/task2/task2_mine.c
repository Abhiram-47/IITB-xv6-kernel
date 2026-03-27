#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <string.h> 
#include <unistd.h>
#include <time.h>

#define CLOCK_MONOTONIC 1

// Define all the required synchronization variables
// TODO
pthread_mutex_t queue_lock;
pthread_cond_t empty;
pthread_cond_t fill;

struct element{
    long long int execution_time;
    struct timespec arrival_time;
};

long long int max_ready_queue_size; // maximum size of the ready queue
long long int push_queue_counter = 0; // critical_variable
long long int pop_queue_counter = 0; // critical_variable
long long int queue_size = 0; // critical_variable
long long int num_cpus; // Number of CPU threads
struct element *ready_queue;    // Ready queue
char input_file[100];   // Input file name for the producer
long long int is_cpu_running = 1;   // Flag that tells the CPU threads to keep on running, change it to exit the CPU threads

// metrics to track
long long int *number_of_lock_requests_per_thread; //to keep track of the number of times each thread requesting for the lock
long long int *total_number_of_tasks_per_thread;//to count the number of tasks/work done by each thread
long long int number_of_drops_by_producer=0;//to count the number of request drops by producer when ready queue is full
long long int *average_wait_time_of_lock_per_thread;//calculating the average time for which each thread has to wait to get the lock
long long int *max_wait_time_of_task;//maximum waiting time of task to get scheduled(among all tasks)
long long int *min_wait_time_of_task;//minimum waiting time of task to get scheduled(among all tasks)
long long int *average_wait_time_of_task;//average waiting time of each thread to dequeue the task from ready queue
long long int average_ready_queue_size = 0; // Average size of the ready queue


// Add all synchronization variables that are required in the producer code, and variables to track the metrics
// TODO
void* producer(void* args) {
    FILE* taskfile = fopen(input_file, "r");
    if (taskfile == NULL) {
        perror("Failed to open the task file");
        exit(1);
    }
    
    long long int total_work;
    fscanf(taskfile, "%lld", &total_work);
    
    long long int num_of_work, execution_time, next_arrival_time;
    while(total_work--) {
        fscanf(taskfile, "%lld %lld %lld", &num_of_work, &execution_time, &next_arrival_time);
        
        for(long long int i=0;i<num_of_work;i++) {
            // Drop the request if the queue is full
            pthread_mutex_lock(&queue_lock);
            if(queue_size == max_ready_queue_size){
                number_of_drops_by_producer++;
                pthread_mutex_unlock(&queue_lock);
                continue;
            }
            
            // Add work to the queue
            ready_queue[push_queue_counter].execution_time = execution_time;
            queue_size++;

            clock_gettime(CLOCK_MONOTONIC, &ready_queue[push_queue_counter].arrival_time); 
            push_queue_counter = (push_queue_counter + 1) % max_ready_queue_size;





            pthread_cond_signal(&fill);
            pthread_mutex_unlock(&queue_lock);
        }
        is_cpu_running = 0;
        pthread_cond_broadcast(&fill);
        usleep(next_arrival_time);
    }
    pthread_exit(NULL);
}


// Write the CPU code along with all the synchronization variables
// TODO
void* cpu(void* args) {
    long long int cpu_id = *((int*)args);       // pass this argument from the main thread

    struct timespec start, end;
    struct timespec lock_start, lock_end;
    struct timespec now;

    while(1) {
    
        clock_gettime(CLOCK_MONOTONIC, &lock_start);

        pthread_mutex_lock(&queue_lock);
        
        clock_gettime(CLOCK_MONOTONIC, &lock_end);
        number_of_lock_requests_per_thread[cpu_id]++;
        long long lock_wait =
            (lock_end.tv_sec - lock_start.tv_sec) * 1000000 +
            (lock_end.tv_nsec - lock_start.tv_nsec) / 1000;
        average_wait_time_of_lock_per_thread[cpu_id] += lock_wait;

        while (queue_size == 0 && is_cpu_running)
            pthread_cond_wait(&fill, &queue_lock);
        if (queue_size == 0 && !is_cpu_running) {
            pthread_mutex_unlock(&queue_lock);
            break;
        }

        struct element task = ready_queue[pop_queue_counter];
        
        ready_queue[pop_queue_counter].execution_time = - 1;
        pop_queue_counter = (pop_queue_counter + 1) % max_ready_queue_size;
        queue_size--;
        
        pthread_cond_signal(&empty);            // not required at all, cuz producer drops the packets!
        pthread_mutex_unlock(&queue_lock);

        total_number_of_tasks_per_thread[cpu_id]++;
        // Calculate waiting time
        clock_gettime(CLOCK_MONOTONIC, &now);
        long long wait_time =
            (now.tv_sec - task.arrival_time.tv_sec) * 1000000 +
            (now.tv_nsec - task.arrival_time.tv_nsec) / 1000;
        average_wait_time_of_task[cpu_id] += wait_time;
        max_wait_time_of_task[cpu_id] = (max_wait_time_of_task[cpu_id] >= wait_time ? max_wait_time_of_task[cpu_id] : wait_time);
        min_wait_time_of_task[cpu_id] = (min_wait_time_of_task[cpu_id] >= wait_time ? wait_time : min_wait_time_of_task[cpu_id]);

        usleep(task.execution_time);
    }

    // calculate averages
    if (number_of_lock_requests_per_thread[cpu_id] > 0)
        average_wait_time_of_lock_per_thread[cpu_id] /= number_of_lock_requests_per_thread[cpu_id];
    if (total_number_of_tasks_per_thread[cpu_id] > 0)
        average_wait_time_of_task[cpu_id] /= total_number_of_tasks_per_thread[cpu_id];
    
    pthread_exit(NULL);
}

// Write the code for tracking the ready queue after periodic intervals from this function (run as separate thread)
// TODO
void* ready_queue_size_tracker(void* args) {
    long long samples = 0;

    while (is_cpu_running) {
        pthread_mutex_lock(&queue_lock);
        average_ready_queue_size += queue_size;
        samples++;
        pthread_mutex_unlock(&queue_lock);

        usleep(1000); // sample every 1ms
    }

    if (samples > 0)
        average_ready_queue_size /= samples;

    pthread_exit(NULL);
}

// Write the logic for starting all the threads in a proper order, and gracefully exiting all the threads to print the metrics at the end
// TODO
int main(long long int argc, char* argv[]) {
    if (argc != 4) {
        perror("Execution syntax: ./task2 <file_name> <cpu_count> <max_ready_queue_size>");
        exit(0);
    }

    strcpy(input_file, argv[1]);
    max_ready_queue_size = atoi(argv[3]);
    num_cpus = atoi(argv[2]);
    ready_queue = malloc(max_ready_queue_size * sizeof(struct element));
    for(long long int i=0; i<max_ready_queue_size; i++) ready_queue[i].execution_time = -1;

    number_of_lock_requests_per_thread = malloc(num_cpus * sizeof(long long int));
    total_number_of_tasks_per_thread=malloc(num_cpus * sizeof(long long int));
    average_wait_time_of_lock_per_thread = malloc(num_cpus * sizeof(long long int));
    max_wait_time_of_task = malloc(num_cpus * sizeof(long long int));
    min_wait_time_of_task = malloc(num_cpus * sizeof(long long int));
    average_wait_time_of_task = malloc(num_cpus * sizeof(long long int));

    for(long long int i=0; i<num_cpus; i++) {
        number_of_lock_requests_per_thread[i] = 0;
        total_number_of_tasks_per_thread[i]=0;
        number_of_drops_by_producer=0;
        average_wait_time_of_lock_per_thread[i] = 0;
        max_wait_time_of_task[i] = 0;
        min_wait_time_of_task[i] = 100000;
        average_wait_time_of_task[i] = 0;
    }

    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    


    pthread_mutex_init(&queue_lock, NULL);
    pthread_cond_init(&empty, NULL);
    pthread_cond_init(&fill, NULL);

    pthread_t prod;
    pthread_t cpus[num_cpus];
    pthread_t tracker;
    
    int cpu_ids[num_cpus];
    
    pthread_create(&prod, NULL, producer, NULL);
    pthread_create(&tracker, NULL, ready_queue_size_tracker, NULL);
    for (long long int i = 0; i < num_cpus; i++) {
        cpu_ids[i] = i;
        pthread_create(&cpus[i], NULL, cpu, &cpu_ids[i]);
    }
    pthread_join(prod, NULL);

    for (long long int i = 0; i < num_cpus; i++)
        pthread_join(cpus[i], NULL);
    pthread_join(tracker, NULL);


    clock_gettime(CLOCK_MONOTONIC, &end);
    long long int total_execution_time = (end.tv_sec - start.tv_sec) * 1000000000 + (end.tv_nsec - start.tv_nsec)/1000;

    double average_waiting_time_of_all_threads=0;
    for(long long int i=0; i<num_cpus; i++) {
        average_waiting_time_of_all_threads+=average_wait_time_of_lock_per_thread[i];
        printf("CPU ID : %lld\n", i);
        printf("Number of lock requests : %lld \n", number_of_lock_requests_per_thread[i]);
        printf("Number of Tasks done: %lld \n", total_number_of_tasks_per_thread[i]);
        printf("Average waiting time for lock : %lld us\n", average_wait_time_of_lock_per_thread[i]);
        printf("Max waiting time of a task : %lld us\n", max_wait_time_of_task[i]);
        printf("Min waiting time of a task : %lld us\n", min_wait_time_of_task[i]);
        printf("Average waiting time of a task : %lld us\n", average_wait_time_of_task[i]);
        printf("\n");
    }
    average_waiting_time_of_all_threads/=num_cpus;
    printf("Number of drops done: %lld\n", number_of_drops_by_producer);
    printf("Average size of ready queue : %lld\n", average_ready_queue_size);
    printf("Total execution time for all the requests : %lld us\n", total_execution_time);
    printf("Average waiting time for all threads %f\n",average_waiting_time_of_all_threads);

    return 0;
}