#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>


#define MAX_TOKEN_SIZE 64
#define MAX_NUM_TOKENS 64

/* Splits the string by space and returns the array of tokens
*
*/
char **tokenize(char *line) {

    // tokenizer variables
	char **tokens = (char **)malloc(MAX_NUM_TOKENS * sizeof(char *));
	char *token = (char *)malloc(MAX_TOKEN_SIZE * sizeof(char));
	int i, tokenIndex = 0, tokenNo = 0;

    // loop on length of line
	for(i=0; i < strlen(line); i++){

		char readChar = line[i];

        // tokenize on any kind of space
		if (readChar == ' ' || readChar == '\n' || readChar == '\t'){
			token[tokenIndex] = '\0';
			if (tokenIndex != 0) {
				tokens[tokenNo] = (char*)malloc(MAX_TOKEN_SIZE*sizeof(char));
				strcpy(tokens[tokenNo++], token);
				tokenIndex = 0; 
			}
		}
		else {
			token[tokenIndex++] = readChar;
		}
	}
    char readChar = line[i];
    if (readChar == '\0'){
        token[tokenIndex] = '\0';
        if (tokenIndex != 0) {
            tokens[tokenNo] = (char*)malloc(MAX_TOKEN_SIZE*sizeof(char));
            strcpy(tokens[tokenNo++], token);
            tokenIndex = 0; 
        }
    }
	free(token);
	tokens[tokenNo] = NULL ;
	return tokens;
}
int main(int argc, char* argv[]) {
    if(argc!=2){
        printf("Please, enter the command in a quotes\n");
        return 0;
    }
    char line[100];
    strcpy(line,argv[1]);

    char *command = strtok(line, "|");
    char **comm1 = tokenize(command);
    command = strtok(NULL, "|");
    char **comm2 = tokenize(command);


    int pd[2];
    pipe(pd);
    // Write your code here
    // ---------------------------------------
    int rc = fork();
    if (rc < 0) {
        perror("Failed to create child process....");
        return 1;
    } else if (rc == 0) {
        // CHILD: write to pipe
        close(pd[0]);               // close unused read end
        dup2(pd[1], 1);             // stdout -> pipe write end
        close(pd[1]);               // close after dup
        execvp(comm1[0], comm1);
        perror("execvp failed");    // in case exec fails
        exit(1);
    } else {
        // PARENT: read from pipe, run comm2
        wait(NULL);                 // wait for child to finish writing
        close(pd[1]);               // close unused write end
        dup2(pd[0], 0);             // stdin <- pipe read end
        close(pd[0]);               // close after dup
        execvp(comm2[0], comm2);
        perror("execvp failed");
        exit(1);
    }


    // ---------------------------------------
    // close(pd[0]);
    // close(pd[1]);
    //Uncomment these lines after forking two processes
    // wait(NULL);
    // wait(NULL);
    return 0;
}