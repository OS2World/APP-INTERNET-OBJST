#define INCL_WINWORKPLACE
#include <os2.h>
#include <stdio.h>
#include <string.h>

HOBJECT 	progobjid;
PSZ		pszClassName="WPProgram";
PSZ             pszTitle;
PSZ             pszDefaultTitle="Objst Default Title";
PSZ		pszSetupString;
PSZ		pszLocation="<WP_DESKTOP>";
ULONG		ulFlags=CO_FAILIFEXISTS;
char		charTitle[500];
char		*space=" ";

main(int argc, char *argv[])
{
   int i;

   if (argc==1) {
      progobjid=WinCreateObject(pszClassName,pszDefaultTitle,pszSetupString,pszLocation,ulFlags);
      if (progobjid==0) {
         printf("\nAn object with that title already exists on the desktop.\n\n");
      } else {
         printf("\nThe Program Object ID is: %6d\n\n",(ULONG) progobjid);
      }
   } else {
      strcat(charTitle,argv[1]);
      for (i=2;i<argc;i++) {
         strcat(charTitle,space);
         strcat(charTitle,argv[i]);
      }
      pszTitle=(PSZ) &charTitle;
      progobjid=WinCreateObject(pszClassName,pszTitle,pszSetupString,pszLocation,ulFlags);
      if (progobjid==0) {
         printf("\nAn object with that title already exists on the desktop.\n\n");
      } else {
         printf("\nThe Program Object ID is: %6d\n\n",(ULONG) progobjid);
      }
   }
}

