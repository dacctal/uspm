void permInstallScript(int argc, char *argv[]) {
  for (int i = 2; argv[i] != NULL; i++) {
    size_t len = strlen("chmod +x ~/.local/share/uspm/repo/") + strlen(argv[i]) + strlen("/install.sh") + 1;
    char *command = (char *)malloc(len);

    printf("Granting install script executable permission...\n");
    sprintf(command, "chmod +x ~/.local/share/uspm/repo/%s/install.sh", argv[i]);
    system(command);

    free(command);
  }
}
