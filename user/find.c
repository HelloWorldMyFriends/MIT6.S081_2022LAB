#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"


char *fmtname(char* path){  /*return path's filename after secondly last slush/*/
    static char buf[DIRSIZ + 1];
    char *p;
    /*
        Find first character after last slash.    
    */
    for(p = path + strlen(path); p >= path && *p != '/'; p--){
        ;
    }
    p++;
    if(strlen(p) >= DIRSIZ){
        return p;
    }
    memmove(buf, p, DIRSIZ);
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
    return buf;
}


void find(char* path, char* filename){
    char buf[512];
    char *p;
    int fd;
    struct dirent de;   /*directory consists of dirents*/
    struct stat st;
    if((fd = open(path, 0)) < 0){
        fprintf(2, "find:cannot open %s\n", path);
        return;
    }
    
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';

    // printf("1. %s\n", buf);

    while(read(fd, &de, sizeof(de)) == sizeof(de)){
        if(de.inum == 0)
            continue;
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;

        // printf("2. %s\n", p);
        // printf("4. %s\n", buf);
        if(stat(buf, &st) < 0){
            printf("find: cannot stat %s\n", buf);
            continue;
        }
        switch(st.type){
            case T_FILE:
                // printf("IM FILE %s AND START TO CMP\n", buf);
                if(strcmp(p, filename) == 0){

                    printf("%s\n", buf);

                }
                continue;
            case T_DIR: /*avoid recurse between '.' and '..'*/
                
                // printf("%s----------\n", buf);
                if((strcmp(p ,".") != 0) && (strcmp(p ,"..") != 0)){
                    find(buf, filename);
                }
                continue;
        }
    }
    close(fd);
    return;
} 

    // if(stat(, &st) < 0){
    //     fprintf(2, "find:cannot fstat %s\n", path);
    //     close(fd);
    //     return 
    // }
    // switch(st.type){
    //     case T_DEVICE:  /*through...*/

    //     case T_DIR:
    //         find();
        // case T_DIR:     /*we should print all files in this directory*/
        //     if(strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)){
        //         printf("find: path too long\n");
        //         break;
        //     }
        //     strcpy(buf, path);
        //     *p++ = '/';
        //     while(read(fd, &de, sizeof(de)) == sizeof(de)){

        //         memmove(p, de.name, DIRSIZ);
        //         p[DIRSIZ] = 0;
        //         printf("%s\n", fmtname(buf));

        //     }
        //     break;


        // case T_FILE:    /*we should print all the files in a directory tree with specific name*/
            


    // }
//     close(fd);
//     return;
// }

int main(int argc, char* argv[]){
    int i;
    if(argc < 3){
        printf("what do you want?\n");
        exit(0);
    }
    for(i = 2; i < argc; ++i){
        find(argv[1], argv[i]);
    }
    exit(0);
}