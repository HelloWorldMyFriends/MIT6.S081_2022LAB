#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

/*TODO*/
void xargs(int argc, char *argv[]){
    char *buf = "/";   /* 
                        buf= '.', '/', '/0' 
                        */
    char *p = buf + sizeof(buf) - 1;
    strcpy(p, argv[1]);

    char *args[];
    printf("we will exec %s soon\n", buf);
    printf("argv is %s\n", argv);
    switch(fork()){
        case -1:
            printf("fork error\n");
            exit(-1);
        case 0:     /*child*/
            exec(buf, argv);

        default:    /*parent*/
            wait(0);
    
    }

}



int main(int argc, char *argv[]){
    int fd;
    if( = open(fd, 0) < 0){
        printf("open error!\n");
        exit(-1);
    }
    
    if(argc < 2){
        printf("format error!\n");
        exit(-1);
    }

    xargs(argc, argv);
    exit(0);
}