#include "types.h"
#include "stat.h"
#include "user.h"

#define MAX_LINE_LENGTH 1024


int main(int argc, char *argv[]) {
	if (argc != 2) {
		printf(2, "Usage: %s <input_file>\n", argv[0]);
		exit();
	}

	int fd = open(argv[1], 0);
	if (fd < 0) {
		printf(2, "Error opening file\n");
		exit();
	}

	char buf[MAX_LINE_LENGTH];
	int bytesRead;

	while ((bytesRead = read(fd, buf, sizeof(buf))) > 0) {
		for (int i = 0; i < bytesRead; i++) {
			if (i + 4 <= bytesRead && buf[i] == 'p' && buf[i + 1] == 'i' && buf[i + 2] == 'n' && buf[i + 3] == 'g') {
				printf(1, "pong\n");
			}
		}
	}


	close(fd);
	exit();
}
