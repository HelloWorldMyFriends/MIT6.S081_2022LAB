#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#define BSIZE 100

int fd[2];
int status;
char byte;
char buf[BSIZE];
int pid;

int main(){
    status = pipe(fd);
    if(status == -1){
    /* an error occur */
    /* TODO */
    exit(-1);
    }

    switch(fork()){
        case -1: /* Handle error */
            break;
        case 0:  /*Child - reads from pipe and reply for parents*/
            /* TODO */
            pid = getpid();
            read(fd[0], buf, 1);
            if(strcmp(buf,"a") == 0){
                printf("%d: received ping\n", pid);
                write(fd[1], "b", 1);
            }
            close(fd[0]);
            close(fd[1]);
            

        default: /* Parent - writes to pipe and reads the answer*/
            /* TODO*/
            pid = getpid();
            write(fd[1], "a", 1);
            wait(0);
            read(fd[0], buf, 1);
            if(strcmp(buf,"b") == 0){
                printf("%d: received pong\n", pid);
            }
            close(fd[0]);
            close(fd[1]);
    }   
exit(0);
}