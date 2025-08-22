#include <stdio.h>
#include <dirent.h>
#include <errno.h>

#include "permRemoveScript.c"
#include "runRemoveScript.c"
#include "onlineRemove.c"

void removePkg(int argc, char *argv[]) {
  printf("Packages queued for removal:\n\n");
  for (int i = 2; argv[i] != NULL; i++) {
    printf("\e[1m\033[32m    %s\e[m\033[m\n", argv[i]);
  }
  printf("\n");
  char confirm[256];
  printf("Confirm Remove [y/n]: ");
  scanf("%s", confirm);

  if(strcmp(confirm, "y") == 0 || strcmp(confirm, "") == 0) {
    for (int i = 2; argv[i] != NULL; i++) {
      size_t len = strlen("~/.local/share/uspm/repo/") + strlen(argv[i]) + 1;
      char *repodir = (char *)malloc(len);
      DIR* repo = opendir(repodir);
      if(repo) {
        closedir(repo);
        permRemoveScript(argc, argv);
        runRemoveScript(argc, argv);
      }
      else {
        onlineRemove(argc, argv);
      }

      free(repodir);
    }
  }
  else {
    printf("Cancelled remove\n");
  }
}
