#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scripting/installPkg.c"
#include "scripting/permRemoveScript.c"
#include "scripting/runRemoveScript.c"
#include "scripting/searchScript.c"

int main(int argc, char *argv[]) {

  if(argc < 2) {
    system("chmod +x ~/.local/share/uspm/repo/uspm/help.sh");
    system("~/.local/share/uspm/repo/uspm/help.sh");
  }

  else {

    if(strcmp(argv[1], "i") == 0) {
      installPkg(argc, argv);
    }

    else if(strcmp(argv[1], "r") == 0) {
      permRemoveScript(argc, argv);
      runRemoveScript(argc, argv);
    }

    else if(strcmp(argv[1], "u") == 0) {
      printf("Granting update script executable permission...\n");
      system("chmod +x ~/.local/share/uspm/repo/uspm/update.sh");
      printf("Updating packages...\n");
      system("~/.local/share/uspm/repo/uspm/update.sh");
    }

    else if(strcmp(argv[1], "s") == 0) {
      searchScript(argc, argv);
    }

  }

  return 0;

}
