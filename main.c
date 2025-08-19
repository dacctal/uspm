#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {

  if(argc < 2) {
    system("chmod +x ~/.local/share/uspm/repo/uspm/help.sh");
    system("~/.local/share/uspm/repo/uspm/help.sh");
  } else {

    if(strcmp(argv[1], "i") == 0) {

      size_t len = strlen("chmod +x ~/.local/share/uspm/repo/") + strlen(argv[2]) + strlen("/install.sh") + 1;
      char *command = (char *)malloc(len);

      if (command == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
      }

      sprintf(command, "chmod +x ~/.local/share/uspm/repo/%s/install.sh", argv[2]);
      printf("Granting install script executable permission...\n");
      system(command);

      //--------//

      len = strlen("~/.local/share/uspm/repo/") + strlen(argv[2]) + strlen("/install.sh") + 1;
      command = (char *)malloc(len);

      if (command == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
      }

      sprintf(command, "~/.local/share/uspm/repo/%s/install.sh", argv[2]);
      printf("Installing package...\n");
      system(command);

      free(command);

    }

    else if(strcmp(argv[1], "u") == 0) {

      printf("Granting update script executable permission...\n");
      system("chmod +x ~/.local/share/uspm/repo/uspm/update.sh");
      printf("Updating packages...\n");
      system("~/.local/share/uspm/repo/uspm/update.sh");

    }

    else if(strcmp(argv[1], "r") == 0) {

      //--chmod remove script--//

      size_t len = strlen("chmod +x ~/.local/share/uspm/repo/") + strlen(argv[2]) + strlen("/remove.sh") + 1;
      char *command = (char *)malloc(len);

      if (command == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
      }

      sprintf(command, "chmod +x ~/.local/share/uspm/repo/%s/remove.sh", argv[2]);
      printf("Granting remove script executable permission...\n");
      system(command);

      //--run remove script--//

      len = strlen("~/.local/share/uspm/repo/") + strlen(argv[2]) + strlen("/remove.sh") + 1;
      command = (char *)malloc(len);

      if (command == NULL) {
        printf("Memory allocation failed.\n");
        return 1;
      }

      sprintf(command, "~/.local/share/uspm/repo/%s/remove.sh", argv[2]);
      printf("Removing package: %s\n", argv[2]);
      system(command);

      free(command);

    }

  }

  return 0;

}
