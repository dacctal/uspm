void runRemoveScript(int argc, char *argv[]) {
  for (int i = 2; argv[i] != NULL; i++) {
    size_t len = strlen("~/.local/share/uspm/repo/") + strlen(argv[i]) + strlen("/remove.sh") + 1;
    char *command = (char *)malloc(len);

    printf("Removing package: %s\n", argv[i]);
    sprintf(command, "~/.local/share/uspm/repo/%s/remove.sh", argv[i]);
    system(command);

    free(command);
  }
}
