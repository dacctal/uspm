#include <stdio.h>
#include <dirent.h>
#include <errno.h>

#include "permInstallScript.c"
#include "runInstallScript.c"
#include "onlineInstall.c"

void installPkg(int argc, char *argv[]) {
  printf("Packages queued for install:\n\n");
  for (int i = 2; argv[i] != NULL; i++) {
    printf("\e[1m\033[32m    %s\e[m\033[m\n", argv[i]);
  }
  printf("\n");
  char confirm[256];
  printf("Confirm install [y/n]: ");
  scanf("%s", confirm);

  if(strcmp(confirm, "y") == 0 || strcmp(confirm, "") == 0) {
    for (int i = 2; argv[i] != NULL; i++) {
      char *home = getenv("HOME");
      const char *subpath = "/.local/share/uspm/repo/";
      size_t len = strlen(home) + strlen(subpath) + strlen(argv[i]) + 1;
      char *repodir = malloc(len);
      snprintf(repodir, len, "%s%s%s", home, subpath, argv[i]);
      DIR* repo = opendir(repodir);
      if(repo) {
        closedir(repo);
        permInstallScript(argc, argv);
        runInstallScript(argc, argv);
      }
      else {
        closedir(repo);
        onlineInstall(argc, argv);
      }

      free(repodir);
    }
  }
  else {
    printf("Cancelled install\n");
  }
}
