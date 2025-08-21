#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>

// Simple fuzzy search function
int fuzzy_match(const char *pattern, const char *text) {
    if (!pattern || !text) return 0;
    
    int pattern_len = strlen(pattern);
    int text_len = strlen(text);
    
    if (pattern_len == 0) return 1;
    if (text_len == 0) return 0;
    
    int pattern_idx = 0;
    for (int i = 0; i < text_len && pattern_idx < pattern_len; i++) {
        if (pattern[pattern_idx] == text[i] || 
            pattern[pattern_idx] == text[i] + 32 || 
            pattern[pattern_idx] == text[i] - 32) {
            pattern_idx++;
        }
    }
    
    return pattern_idx == pattern_len;
}

// Check if package is installed
int is_package_installed(const char *package_name) {
    char bin_path[512];
    snprintf(bin_path, sizeof(bin_path), "%s/.local/share/uspm/bin/%s", getenv("HOME"), package_name);
    return access(bin_path, F_OK) == 0;
}

// Get installed version (simplified - just check if installed)
char* get_installed_version(const char *package_name) {
    static char version[64];
    if (is_package_installed(package_name)) {
        strcpy(version, "[ Installed ]");
    } else {
        strcpy(version, "[ Not Installed ]");
    }
    return version;
}

// Get file size in human readable format
char* get_file_size(const char *path) {
    struct stat st;
    static char size_str[32];
    
    if (stat(path, &st) == 0) {
        long size = st.st_size;
        if (size < 1024) {
            snprintf(size_str, sizeof(size_str), "%ld B", size);
        } else if (size < 1024 * 1024) {
            snprintf(size_str, sizeof(size_str), "%.1f KiB", size / 1024.0);
        } else if (size < 1024 * 1024 * 1024) {
            snprintf(size_str, sizeof(size_str), "%.1f MiB", size / (1024.0 * 1024.0));
        } else {
            snprintf(size_str, sizeof(size_str), "%.1f GiB", size / (1024.0 * 1024.0 * 1024.0));
        }
    } else {
        strcpy(size_str, "Unknown");
    }
    
    return size_str;
}

// Get total size of package (sources + binaries)
char* get_package_size(const char *package_name) {
    char sources_path[512];
    char bin_path[512];
    snprintf(sources_path, sizeof(sources_path), "%s/.local/share/uspm/sources/%s", getenv("HOME"), package_name);
    snprintf(bin_path, sizeof(bin_path), "%s/.local/share/uspm/bin/%s", getenv("HOME"), package_name);
    
    struct stat st;
    long total_size = 0;
    
    // Get sources size
    if (stat(sources_path, &st) == 0) {
        total_size += st.st_size;
    }
    
    // Get binary size
    if (stat(bin_path, &st) == 0) {
        total_size += st.st_size;
    }
    
    static char size_str[32];
    if (total_size < 1024) {
        snprintf(size_str, sizeof(size_str), "%ld B", total_size);
    } else if (total_size < 1024 * 1024) {
        snprintf(size_str, sizeof(size_str), "%.1f KiB", total_size / 1024.0);
    } else if (total_size < 1024 * 1024 * 1024) {
        snprintf(size_str, sizeof(size_str), "%.1f MiB", total_size / (1024.0 * 1024.0));
    } else {
        snprintf(size_str, sizeof(size_str), "%.1f GiB", total_size / (1024.0 * 1024.0 * 1024.0));
    }
    
    return size_str;
}

// Get latest version for git packages
char* get_git_version(const char *package_name) {
    static char version[128];
    char install_path[512];
    snprintf(install_path, sizeof(install_path), "%s/.local/share/uspm/repo/%s/install.sh", getenv("HOME"), package_name);
    
    FILE *file = fopen(install_path, "r");
    if (!file) {
        strcpy(version, "Unknown");
        return version;
    }
    
    char line[512];
    char clone_url[256] = "";
    
    // Look for git clone URL
    while (fgets(line, sizeof(line), file)) {
        if (strstr(line, "git clone") && strstr(line, ".git")) {
            char *start = strstr(line, "https://");
            if (start) {
                char *end = strstr(start, ".git");
                if (end) {
                    int len = end - start + 4;
                    strncpy(clone_url, start, len);
                    clone_url[len] = '\0';
                    break;
                }
            }
        }
    }
    fclose(file);
    
    if (strlen(clone_url) == 0) {
        strcpy(version, "Unknown");
        return version;
    }
    
    // Execute git ls-remote command
    char command[512];
    snprintf(command, sizeof(command), 
             "git ls-remote --tags --sort=\"v:refname\" '%s' | tail -n1 | sed 's/.*\\///; s/\\^{}//'", 
             clone_url);
    
    FILE *pipe = popen(command, "r");
    if (!pipe) {
        strcpy(version, "Unknown");
        return version;
    }
    
    if (fgets(version, sizeof(version), pipe) != NULL) {
        version[strcspn(version, "\n")] = 0;
        if (strlen(version) == 0) {
            strcpy(version, "Unknown");
        }
    } else {
        strcpy(version, "Unknown");
    }
    
    pclose(pipe);
    return version;
}

// Parse TOML file and extract package info
void parse_package_info(const char *package_name, const char *toml_path) {
    FILE *file = fopen(toml_path, "r");
    if (!file) {
        printf("      Latest version available: [ No metadata ]\n");
        printf("      Latest version installed: %s\n", get_installed_version(package_name));
        printf("      Size of files: %s\n", get_package_size(package_name));
        printf("      Source:      [ No metadata ]\n");
        printf("      Description:   [ No metadata ]\n");
        printf("      License:       [ No metadata ]\n\n");
        return;
    }
    
    char line[512];
    char version[128] = "Unknown";
    char source[256] = "Unknown";
    char description[512] = "No description available";
    char license[128] = "Unknown";
    
    while (fgets(line, sizeof(line), file)) {
        line[strcspn(line, "\n")] = 0;
        
        if (strncmp(line, "version = ", 10) == 0) {
            strcpy(version, line + 10);
            // Remove quotes if present
            if (version[0] == '"') {
                memmove(version, version + 1, strlen(version));
                if (version[strlen(version) - 1] == '"') {
                    version[strlen(version) - 1] = '\0';
                }
            }
            // Remove any trailing quotes or spaces
            int len = strlen(version);
            while (len > 0 && (version[len-1] == '"' || version[len-1] == ' ')) {
                version[--len] = '\0';
            }
        } else if (strncmp(line, "source = ", 9) == 0) {
            strcpy(source, line + 9);
            if (source[0] == '"') {
                memmove(source, source + 1, strlen(source));
                if (source[strlen(source) - 1] == '"') {
                    source[strlen(source) - 1] = '\0';
                }
            }
            // Remove any trailing quotes or spaces
            int len = strlen(source);
            while (len > 0 && (source[len-1] == '"' || source[len-1] == ' ')) {
                source[--len] = '\0';
            }
        } else if (strncmp(line, "description = ", 13) == 0) {
            strcpy(description, line + 13);
            if (description[0] == '"') {
                memmove(description, description + 1, strlen(description));
                if (description[strlen(description) - 1] == '"') {
                    description[strlen(description) - 1] = '\0';
                }
            }
            // Remove any trailing quotes or spaces
            int len = strlen(description);
            while (len > 0 && (description[len-1] == '"' || description[len-1] == ' ')) {
                description[--len] = '\0';
            }
        } else if (strncmp(line, "license = ", 10) == 0) {
            strcpy(license, line + 10);
            if (license[0] == '"') {
                memmove(license, license + 1, strlen(license));
                if (license[strlen(license) - 1] == '"') {
                    license[strlen(license) - 1] = '\0';
                }
            }
            // Remove any trailing quotes or spaces
            int len = strlen(license);
            while (len > 0 && (license[len-1] == '"' || license[len-1] == ' ')) {
                license[--len] = '\0';
            }
        }
    }
    fclose(file);
    
    // Check if it's a git package and get version
    if (strcmp(version, "Unknown") == 0) {
        char *git_version = get_git_version(package_name);
        if (strcmp(git_version, "Unknown") != 0) {
            strcpy(version, git_version);
        }
    }
    
    printf("      Latest version available: %s\n", version);
    printf("      Latest version installed: %s\n", get_installed_version(package_name));
    printf("      Size of files: %s\n", get_package_size(package_name));
    printf("      Source:      %s\n", source);
    printf("      Description:   %s\n", description);
    printf("      License:       %s\n\n", license);
}

// Enhanced search function that searches package name and description
int enhanced_search(const char *search_term, const char *package_name, const char *toml_path) {
    // First check if search term matches package name
    if (fuzzy_match(search_term, package_name)) {
        return 1;
    }
    
    // Then check if search term matches any content in TOML file
    FILE *file = fopen(toml_path, "r");
    if (!file) {
        return 0;
    }
    
    char line[512];
    while (fgets(line, sizeof(line), file)) {
        line[strcspn(line, "\n")] = 0;
        
        // Convert line to lowercase for case-insensitive search
        char lower_line[512];
        strcpy(lower_line, line);
        for (int i = 0; lower_line[i]; i++) {
            if (lower_line[i] >= 'A' && lower_line[i] <= 'Z') {
                lower_line[i] = lower_line[i] + 32;
            }
        }
        
        // Convert search term to lowercase
        char lower_search[256];
        strcpy(lower_search, search_term);
        for (int i = 0; lower_search[i]; i++) {
            if (lower_search[i] >= 'A' && lower_search[i] <= 'Z') {
                lower_search[i] = lower_search[i] + 32;
            }
        }
        
        // Check if search term is found in the line
        if (strstr(lower_line, lower_search) != NULL) {
            fclose(file);
            return 1;
        }
    }
    
    fclose(file);
    return 0;
}

void searchScript(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: uspm s <search-term1> [search-term2] [search-term3] ...\n");
        printf("Example: uspm s python rust\n");
        return;
    }
    
    char repo_path[512];
    snprintf(repo_path, sizeof(repo_path), "%s/.local/share/uspm/repo", getenv("HOME"));
    
    DIR *dir = opendir(repo_path);
    if (!dir) {
        printf("Error: Could not open repository directory\n");
        return;
    }
    
    struct dirent *entry;
    
    // Display results for each search term
    for (int i = 2; i < argc; i++) {
        rewinddir(dir);
        int found_count = 0;
        
        printf("[ Results for search key : %s ]\n", argv[i]);
        printf("Searching...\n\n");
        
        while ((entry = readdir(dir)) != NULL) {
            if (entry->d_type == DT_DIR && strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
                char toml_path[512];
                snprintf(toml_path, sizeof(toml_path), "%s/%s/package.toml", repo_path, entry->d_name);
                
                if (enhanced_search(argv[i], entry->d_name, toml_path)) {
                    printf("%s\n", entry->d_name);
                    parse_package_info(entry->d_name, toml_path);
                    found_count++;
                }
            }
        }
        
        if (found_count == 0) {
            printf("No packages found matching '%s'\n", argv[i]);
        }
        
        printf("[ Applications found : %d ]\n", found_count);
        
        if (i < argc - 1) {
            printf("\n");
        }
    }
    
    closedir(dir);
} 