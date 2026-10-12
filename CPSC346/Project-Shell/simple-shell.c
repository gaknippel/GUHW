/**
 * Project 4 — UNIX Shell and History Feature
 *
 * Add author information here.
 */

#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_LINE 80       /* Maximum command size (80 chars), including room for '\0'. */
#define MAX_COMMANDS 9    /* Number of commands stored in history. */

#define SETUP_EXIT 0
#define SETUP_EXECUTE 1
#define SETUP_SKIP -1

/* Stores commands in a form that can be recalled and executed. */
char history[MAX_COMMANDS][MAX_LINE];

/* Number of commands successfully added to history since startup. */
int command_count = 0;

/**
 * Add the most recent command to history.
 *
 * Requirements:
 * - Keep only the MAX_COMMANDS most recent commands.
 * - history should preserve the command in a form that can be executed again.
 * - A circular-array approach is recommended.
 */
void addtohistory(char inputBuffer[]) {
	strcpy(history[command_count % MAX_COMMANDS], inputBuffer);
	command_count++;

	return;
}

/**
 * Read and prepare the next command. 
 *
 * Return values:
 *   SETUP_EXECUTE - a command is ready for main() to process
 *   SETUP_SKIP    - ignore this input and display another prompt
 *   SETUP_EXIT    - terminate the shell (CTRL-D / end of input)
 *
 * The function should:
 * - read a line from standard input,
 * - handle !! and !N history requests,
 * - add commands to the history,
 * - split the command into null-terminated argument strings,
 * - fill args with pointers to the beginning of those strings, and terminate args with NULL.
 * - set *background
 */
int setup(char inputBuffer[], char *args[], int *background) {
	int length; /* Number of characters read. */
	int i;      /* Index used to examine inputBuffer. */
	int start = -1;
	int arg_index = 0;

	/*
	 * Read what the user enters on the command line.
	 *
	 * read() does NOT append '\0', so read at most MAX_LINE - 1 characters
	 * and add the terminator after checking the return value.
	 */
	do {
		printf("osh> ");
		fflush(stdout);

		length = read(STDIN_FILENO, inputBuffer, MAX_LINE - 1);

		if (length == 0) {
			/* CTRL-D / end of input. */
			return SETUP_EXIT;
		}

		if (length < 0) {
			perror("error reading the command");
			exit(EXIT_FAILURE);
		}

		/* Make inputBuffer a valid C string. */
		inputBuffer[length] = '\0';

	/* Ignore a line containing only Enter and display another prompt. */
	} while (length == 1 && inputBuffer[0] == '\n');
	

	if (inputBuffer[0] == '!') {
		if (inputBuffer[1] == '!') {
			/* !! */
			if (command_count == 0) {
				printf("No commands in history.\n");
				return SETUP_SKIP;
			}
			strcpy(inputBuffer, history[(command_count - 1) % MAX_COMMANDS]);
			printf("%s", inputBuffer);          /* echo  */
			length = strlen(inputBuffer);
		}
		else if (isdigit(inputBuffer[1])) {
			/* !N  */
			int n = inputBuffer[1] - '0';       

			if (n < 1 || n > command_count || n > MAX_COMMANDS) {
				printf("No such command in history.\n");
				return SETUP_SKIP;
			}
			strcpy(inputBuffer, history[(command_count - n) % MAX_COMMANDS]);
			printf("%s", inputBuffer);
			length = strlen(inputBuffer);
		}
		else {
			/* "!" */
			printf("No such command in history.\n");
			return SETUP_SKIP;
		}
	}

	addtohistory(inputBuffer);

	for (i = 0; i < length; i++) {
		switch (inputBuffer[i]) {
			case ' ':
			case '\t':
			if (start != -1) {
				args[arg_index] = &inputBuffer[start];
				arg_index++;
				start = -1;
			}
			inputBuffer[i] = '\0';
			break;
			case '\n':
			if (start != -1) {
				args[arg_index] = &inputBuffer[start];
				arg_index++;
				start = -1;
			}
			inputBuffer[i] = '\0';
				break;
			default:
			if (start == -1) {
				start = i;
			}
			break;
		}
	}
	if (start != -1) {
		args[arg_index] = &inputBuffer[start];
		arg_index++;
	}
	if(arg_index == 0){
		return SETUP_SKIP;
	}
	if (strcmp(args[arg_index - 1], "&") == 0) {
		*background = 1;
		arg_index--;          /* drop "&" from args */
	}
	if (arg_index == 0) {     /* user typed only "&" */
		return SETUP_SKIP;
	}
	args[arg_index] = NULL;

	return SETUP_EXECUTE;
}

int main(void) {
	char inputBuffer[MAX_LINE];
	char *args[MAX_LINE / 2 + 1]; /* Up to 40 args plus the final NULL. */
	int background;
	int setup_result;
	pid_t child;

	while (1) {
		background = 0;

		setup_result = setup(inputBuffer, args, &background);

		if (setup_result == SETUP_EXIT) {
			break;
		}

		if (setup_result == SETUP_SKIP) {
			continue;
		}

		for (int k = 0; args[k] != NULL; k++)
			printf("args[%d] = \"%s\"\n", k, args[k]);
		printf("background = %d\n", background);

		if (strcmp(args[0], "exit") == 0){
			break;
		}

		/**
		 * Part II — Built-in history
		 *
		 * If the command is exactly "history": 
        */
		// TODO Part II: display history.


		child = fork();

		if(child < 0){
			perror("fork failed");
		}
		else if (child == 0){
			execvp(args[0], args);

			perror("execvp failed");
			exit(EXIT_FAILURE);
		}
		else {
			if(background == 0){
				waitpid(child, NULL, 0);
			}
		}
        
	}

	return 0;
}
