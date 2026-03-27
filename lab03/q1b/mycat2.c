#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    int stdin_fd = 0;

    int stdout_fd = 1;
    char character[1];
    while (read(stdin_fd, character, 1) > 0) {
        write(stdout_fd, character, 1);
    }

    return 0;
}