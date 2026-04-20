#include<stdio.h>


int sumArray(int arr[], int size);


int main(){
    int arr[] = {1,2,3,4,5};
    int size = 5;

    int answer = sumArray(arr, size);

    for(int i = 0; i <5; i++){
        printf("%d ", arr[i]);
    }
    printf("\n");

    return 0;

}