void updateUspm() {
  printf("Self-updating USPM...\n");
  printf("Cloning latest version from GitHub...\n");

  // Create a unique temporary directory name
  char temp_dir[256];
  snprintf(temp_dir, sizeof(temp_dir), "/tmp/uspm-update-%d", getpid());

  // Clone the repository to a safe temporary location
  char clone_command[512];
  snprintf(clone_command, sizeof(clone_command), 
           "git clone https://github.com/dacctal/uspm.git %s", temp_dir);

  if (system(clone_command) != 0) {
    printf("Error: Failed to clone USPM repository\n");
    printf("Please check your internet connection and try again\n");
  }

  printf("Building and installing latest version...\n");

  // Change to the cloned directory and run build.sh
  char build_command[512];
  snprintf(build_command, sizeof(build_command), 
           "cd %s && chmod +x build.sh && ./build.sh", temp_dir);

  int build_result = system(build_command);

  // Clean up the temporary directory safely
  char cleanup_command[512];
  snprintf(cleanup_command, sizeof(cleanup_command), "rm -rf %s", temp_dir);
  system(cleanup_command);

  if (build_result == 0) {
    printf("\n\033[32m  USPM successfully updated to the latest version!\033[0m\n");
    printf("You can now use all the latest features and improvements.\n");
  } else {
    printf("\033[31m  Error: Failed to build USPM\033[0m\n");
    printf("Please check the error messages above and try again\n");
  }
}
