#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#define BSIZE 100
#define N 35
#define RD 0
#define WR 1 

int buf[BSIZE];
// int pid;
int status;
int count;
// int first;

int lpipe_first_data(int *lpipe, int *first){
    // printf("a\n");
    if(read(lpipe[RD], first, sizeof(int)) == sizeof(int)){
        printf("prime %d\n", *first);
        return 0;
    }
    // printf("b\n");
    return 1;
}

void transmit_data(int *lpipe, int *rpipe, int first){
    int data;
    while(read(lpipe[RD], &data, sizeof(int)) == sizeof(int)){  /**/
        if(data % first){
            write(rpipe[WR], &data, sizeof(int));
            // printf("%d ", data);
        }
    }
    close(lpipe[RD]);
    close(rpipe[WR]);
    // printf("\ne----------\n");
}

void primes(int *lpipe){
    int first;
    
    close(lpipe[WR]);
    // printf("d\n");  /**/
    if(lpipe_first_data(lpipe, &first)){
        // printf("exit\n");
        exit(0);
    }
    int rpipe[2];
    pipe(rpipe);

    // printf("first = %d---------", first);

    transmit_data(lpipe, rpipe, first);
    switch(fork()){
        case -1:    /*error*/
            printf("error shit\n");
            break;
        case 0:     /*child*/
            // printf("child %d\n", count++);
            primes(rpipe);
            break;
        default:    /*parent*/
            close(rpipe[RD]);
            wait(0);
            // printf("parent end\n");
            break;
    }
}


int main(int argc, const char* argv){
    int lpipe[2];
    int i;
    pipe(lpipe);
    for(i = 2; i <= N ;++i){
        write(lpipe[WR], &i, sizeof(int));
    }
    
    switch(fork()){
        case -1:    /*error*/
            exit(-1);
        case 0:     /*child*/
            // printf("child %d\n", count++);
            primes(lpipe);
            exit(0);
        default:    /*parent*/
            close(lpipe[RD]);
            close(lpipe[WR]);
            wait(0);
            exit(0);
    }
}





