#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {

    int rd_fd = open("in.txt", O_RDONLY);
    if (rd_fd == -1) {
        perror("Failed to open the file");
        return 1;
    }

    int wr_fd = open("out.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666);
    if (wr_fd == -1) {
        perror("Failed to open the file");
        return 1;
    }

    int stdin_fd = 0;
    int stdout_fd = 1;

    dup2(rd_fd, stdin_fd);
    dup2(wr_fd, stdout_fd);

    char character[1];
    while (read(stdin_fd, character, 1) > 0) {
        write(stdout_fd, character, 1);
    }

    close(rd_fd);
    close(wr_fd);
    return 0;
}