#include <stdlib.h>
#include <stdio.h>

struct node{
	int data;
	struct node * next;
};

void printlist(struct node *head);
int getlistlength(struct node *head);
struct node* mergesort(struct node* head, int size);
struct node* merge(struct node * head1, struct node * head2);

//print list-----------------------

void printlist(struct node *head){
	struct node *current = head;
	while(current != NULL){
		printf("%d ", current->data);
		current = current->next;
	}
	printf("\n");
}

//get list length-----------------------


int getlistlength(struct node *head){
	struct node *current = head;
	int counter = 0;
	while(current != NULL){
		current = current->next;
		counter++;
	}
	return counter;
}

//merge-----------------------


struct node* merge(struct node * head1, struct node * head2){
	struct node dummy;
	struct node *tail = &dummy;

	while(head1 != NULL && head2 != NULL){
		if(head1->data <= head2->data){
			tail->next = head1;
			head1 = head1->next;
		}
		else {
			tail->next = head2;
			head2 = head2->next;
		}
		tail = tail->next;
	}
	if(head1 != NULL){
		tail->next = head1;
	}
	else{
		tail->next = head2;
	}

	return dummy.next;
}

//merge sort-----------------------

struct node *mergesort(struct node *head, int size){
	if(size <= 1){
		return head;
	}

	int size1 = size /2;
	int size2 = size - size1;

	struct node *current = head;
	for(int i = 1; i < size1; i++){
		//move current forward one node
		current = current->next;
	}

	struct node *head2 = current->next; //starts second list
	current->next = NULL; //cuts off first list

	struct node *sorted1 = mergesort(head, size1);
	struct node *sorted2 = mergesort(head2, size2);

	return merge(sorted1, sorted2);

}



int main(){

	struct node f = {7, NULL};
	struct node e = {6, &f};
	struct node d = {1, &e};
	struct node c = {9, &d};
	struct node b = {5, &c};
	struct node a = {3, &b};


	struct node x = {0, NULL};




	printlist(&a);



	//struct node* merged = merge(&d, &a);

	//printlist(merged);


	//int length = getlistlength(NULL);

	///printf("%d ",length);

	struct node* sorted = mergesort(&a, getlistlength(&a));

		printlist(sorted);

	return 0;
}