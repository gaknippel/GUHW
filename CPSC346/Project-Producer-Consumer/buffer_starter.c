#include "buffer2.h"
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>     // sleep()

buffer_item buffer[BUFFER_SIZE];
// TODO: declare global variables here
sem_t empty;            // coutns empty slots
sem_t full;             // counts full slots
pthread_mutex_t mutex;  
int next_add = 0;       // index where the next produced item goes
int next_remove = 0;    // index where the next consumed item gets consumed

void print_buffer(){
    for(int i = 0; i < BUFFER_SIZE-1; i++){
        printf("%d, ", buffer[i]);
    }
    printf("%d\n", buffer[BUFFER_SIZE-1]);
}

int insert_item(buffer_item item){
    // TODO: fill out this function so it is thread safe
    sem_wait(&empty);              
    pthread_mutex_lock(&mutex);

    buffer[next_add] = item;
    printf("ADDING %d at %d\n", item, next_add);
    next_add = (next_add + 1) % BUFFER_SIZE;  //circular array

    pthread_mutex_unlock(&mutex);  
    sem_post(&full);               

    return 0; //return 0 on success
}
int remove_item(buffer_item *item){
    // TODO: fill out this function so it is thread safe
    sem_wait(&full);               
    pthread_mutex_lock(&mutex);

    *item = buffer[next_remove];   
    printf("REMOVING %d at %d\n", *item, next_remove);
    next_remove = (next_remove + 1) % BUFFER_SIZE;  // circular array

    pthread_mutex_unlock(&mutex);
    sem_post(&empty);              

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
    sem_init(&empty, 0, BUFFER_SIZE);   
    sem_init(&full, 0, 0);              
    pthread_mutex_init(&mutex, NULL);   

    pthread_t producers[prod];
    pthread_t consumers[con];

    for (int i = 0; i < prod; i++){
        pthread_create(&producers[i], NULL, producer, NULL);
    }
    for (int i = 0; i < con; i++){
        pthread_create(&consumers[i], NULL, consumer, NULL);
    }

    sleep(sleep_time);

    return 0;
}