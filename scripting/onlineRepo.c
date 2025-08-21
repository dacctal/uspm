#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

#define MAX_PACKAGES 100
#define MAX_PACKAGE_NAME 64
#define MAX_URL_LENGTH 512
#define MAX_TOML_CONTENT 4096

// Base URL for the online repository
static const char* BASE_URL = "https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo";

// Function to check if a URL exists (returns 1 if exists, 0 if not)
int url_exists(const char* url) {
    char command[1024];
    snprintf(command, sizeof(command), 
             "curl -s --head --fail \"%s\" >/dev/null 2>&1", url);
    return system(command) == 0;
}

// Function to download content from URL
char* download_url_content(const char* url) {
    char command[1024];
    static char content[MAX_TOML_CONTENT];
    
    snprintf(command, sizeof(command), 
             "curl -s --fail \"%s\" 2>/dev/null", url);
    
    FILE* pipe = popen(command, "r");
    if (!pipe) {
        return NULL;
    }
    
    size_t bytes_read = fread(content, 1, sizeof(content) - 1, pipe);
    content[bytes_read] = '\0';
    
    pclose(pipe);
    
    if (bytes_read == 0) {
        return NULL;
    }
    
    return content;
}

// Function to get list of available packages from online repo
int get_online_package_list(char packages[][MAX_PACKAGE_NAME], int max_packages) {
    // For now, we'll use a hardcoded list based on the known packages
    // In a more sophisticated implementation, this could fetch from a package index
    const char* known_packages[] = {
        "cairo", "cmake", "curl", "discord", "docker", "fastfetch", 
        "foot", "fuzzel", "gammastep", "gnu-coreutils", "llvm", 
        "make", "meson", "ninja", "otter-launcher", "pipes.sh", 
        "python", "rust", "unimatrix", "uspm", "waybar", "yad"
    };
    
    int count = 0;
    int known_count = sizeof(known_packages) / sizeof(known_packages[0]);
    
    for (int i = 0; i < known_count && count < max_packages; i++) {
        char package_url[MAX_URL_LENGTH];
        snprintf(package_url, sizeof(package_url), 
                "%s/%s/package.toml", BASE_URL, known_packages[i]);
        
        // Check if package exists online
        if (url_exists(package_url)) {
            strncpy(packages[count], known_packages[i], MAX_PACKAGE_NAME - 1);
            packages[count][MAX_PACKAGE_NAME - 1] = '\0';
            count++;
        }
    }
    
    return count;
}

// Function to get package.toml content from online repo
char* get_online_package_toml(const char* package_name) {
    char package_url[MAX_URL_LENGTH];
    snprintf(package_url, sizeof(package_url), 
            "%s/%s/package.toml", BASE_URL, package_name);
    
    return download_url_content(package_url);
}

// Function to check if local repo exists and has packages
int local_repo_exists() {
    char repo_path[512];
    snprintf(repo_path, sizeof(repo_path), "%s/.local/share/uspm/repo", getenv("HOME"));
    
    struct stat st;
    if (stat(repo_path, &st) != 0) {
        return 0; // Directory doesn't exist
    }
    
    if (!S_ISDIR(st.st_mode)) {
        return 0; // Not a directory
    }
    
    // Check if there are any package directories
    char command[1024];
    snprintf(command, sizeof(command), 
             "find \"%s\" -maxdepth 1 -type d -name \"*\" | wc -l", repo_path);
    
    FILE* pipe = popen(command, "r");
    if (!pipe) {
        return 0;
    }
    
    char result[16];
    if (fgets(result, sizeof(result), pipe) != NULL) {
        pclose(pipe);
        int count = atoi(result);
        return count > 2; // More than just . and ..
    }
    
    pclose(pipe);
    return 0;
}
