#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

const char *buffer = "nothing happens for a little while\n"; 
unsigned int t; //sleep time t

int
main(int argc, char *argv[])
{
  t = atoi(argv[1]);
  if(t != 0){
     write(1, buffer, strlen(buffer));
     sleep(t);	
   }
exit(0);

}
