#define INCL_WINWORKPLACE
#include <os2.h>
#include <string.h>

HOBJECT openobj;
char *keystring="PARAMETERS=";
char paramstring[500];
char *space=" ";

main(int argc, char *argv[])
{
   int i;

   strcat(paramstring,keystring);
   if (argc>1) {
      openobj=(HOBJECT)(atoi(argv[1]));
      strcat(paramstring,argv[2]);
      for (i=3;i<argc;i++) {
         strcat(paramstring,space);
         strcat(paramstring,argv[i]);
      }
      WinSetObjectData(openobj,paramstring);
      WinSetObjectData(openobj,"OPEN=DEFAULT");
   }
}



