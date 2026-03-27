#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf(1, "Usage: %s <program_to_execute> [arguments...]\n", argv[0]);
        exit();
    }

    int pid = fork();

    if (pid < 0) {
        printf(1, "Fork failed\n");
    } else if (pid == 0) {
        // This code runs in the child process
        exec(argv[1], argv + 1);
        // If exec fails, it will continue executing this line
        printf(1, "Exec failed\n");
        exit();
    } else {
        // This code runs in the parent process
        wait();
    }

    exit();
}