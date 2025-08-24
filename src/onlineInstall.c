#include <stdio.h>

void onlineInstall(int argc, char *argv[]) {
  for (int i = 2; argv[i] != NULL; i++) {
    size_t len = strlen("curl https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/") + strlen(argv[i]) + strlen("/install.sh | sh") + 1;
    char *command = (char *)malloc(len);

    printf("Installing %s...\n", argv[i]);
    sprintf(command, "curl https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo/%s/install.sh | sh", argv[i]);
    system(command);

    free(command);
  }
}
