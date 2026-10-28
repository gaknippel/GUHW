#include "buffer2.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>

buffer_item buffer[BUFFER_SIZE];
// TODO: declare global variables here

void print_buffer(){
    for(int i = 0; i < BUFFER_SIZE-1; i++){
        printf("%d, ", buffer[i]);
    }
    printf("%d\n", buffer[BUFFER_SIZE-1]);
}

int insert_item(buffer_item item){
    // TODO: fill out this function so it is thread safe

    // printf("ADDING %d at %d\n", item, next_add);

    return 0; // return 0 on success
}
int remove_item(buffer_item *item){
    // TODO: fill out this function so it is thread safe
    // printf("REMOVING %d at %d\n", *item, next_remove);

    return 0; // return 0 on success
}

void * producer(void * arg){
    buffer_item item;
    int r;
    while(1){
        r = rand() % 5;
        sleep(r);
        
        item = rand();
        if (insert_item(item)){
            fprintf(stderr, "report error condition, Producer");
        }
        else{
            printf("producer produced %d\n",item); 
        }
    }
}

void * consumer(void * arg){
    buffer_item item;
    int r;
    while(1){
        r = rand() % 5;
        sleep(r);
        
        item = rand();

        if (remove_item(&item)){
            fprintf(stderr, "report error condition, Consumer");
        }
        else{
            printf("consumer consumed %d\n",item);
        }
    }
}


int main(int argc, char *argv[]) {
    int sleep_time = 3, prod = 10, con = 10;
    if (argc != 4){
        printf("USAGE:./a.out <sleep_time> <producer thread count> <consumer thread count>\n");
        return -1;
    }
    sleep_time = atoi(argv[1]);   // argv[1]=sleep seconds
    prod       = atoi(argv[2]);   // argv[2]=# producers
    con        = atoi(argv[3]);   // argv[3]=# consumers

    // TODO: Initialize semaphores, create producer threads, create consumer threads

    sleep(sleep_time);

    return 0;
}