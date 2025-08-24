#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>
#include <unistd.h>
#include <ctype.h>
#include "getVersion.c"
#include "onlineRepo.c"

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

static void trim_whitespace(char *s) {
    if (!s) return;
    size_t len = strlen(s);
    size_t start = 0;
    while (start < len && isspace((unsigned char)s[start])) start++;
    size_t end = len;
    while (end > start && isspace((unsigned char)s[end - 1])) end--;
    if (start > 0 || end < len) {
        memmove(s, s + start, end - start);
        s[end - start] = '\0';
    }
}

static void strip_quotes(char *s) {
    if (!s) return;
    // Remove leading quotes repeatedly
    while (s[0] == '"' || s[0] == '\'') {
        memmove(s, s + 1, strlen(s));
    }
    // Remove trailing quotes repeatedly
    size_t l = strlen(s);
    while (l > 0 && (s[l - 1] == '"' || s[l - 1] == '\'')) {
        s[--l] = '\0';
    }
}

static void sanitize_value(char *s) {
    trim_whitespace(s);
    strip_quotes(s);
    trim_whitespace(s);
}

// Check if package is installed
int is_package_installed(const char *package_name) {
    char path_buf[1024];

    // Check uspm-managed bin
    snprintf(path_buf, sizeof(path_buf), "%s/.local/share/uspm/bin/%s", getenv("HOME"), package_name);
    if (access(path_buf, F_OK) == 0) {
        return 1;
    }

    // Check uspm-managed applications desktop entry
    snprintf(path_buf, sizeof(path_buf), "%s/.local/share/uspm/bin/applications/%s.desktop", getenv("HOME"), package_name);
    if (access(path_buf, F_OK) == 0) {
        return 1;
    }

    return 0;
}

// Get installed version (simplified - just check if installed)
char* get_installed_version(const char *package_name) {
    static char version[256];

    if (!is_package_installed(package_name)) {
        strcpy(version, "[ Not Installed ]");
        return version;
    }

    // Try to derive installed version from git describe in sources dir
    char src_path[512];
    snprintf(src_path, sizeof(src_path), "%s/.local/share/uspm/sources/%s", getenv("HOME"), package_name);

    char command[768];
    snprintf(command, sizeof(command), "git -C '%s' describe 2>/dev/null", src_path);

    FILE *pipe = popen(command, "r");
    if (!pipe) {
        strcpy(version, "[ Installed ]");
        return version;
    }

    char describe_out[256] = {0};
    if (fgets(describe_out, sizeof(describe_out), pipe) != NULL) {
        describe_out[strcspn(describe_out, "\n")] = 0;
    }
    pclose(pipe);

    if (describe_out[0] != '\0') {
        snprintf(version, sizeof(version), "[ installed %s ]", describe_out);
    } else {
        strcpy(version, "[ Installed ]");
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
            sanitize_value(version);
        } else if (strncmp(line, "source = ", 9) == 0) {
            strcpy(source, line + 9);
            sanitize_value(source);
        } else if (strncmp(line, "description = ", 13) == 0) {
            strcpy(description, line + 13);
            sanitize_value(description);
        } else if (strncmp(line, "license = ", 10) == 0) {
            strcpy(license, line + 10);
            sanitize_value(license);
        }
    }
    fclose(file);

    // Prefer tag lookup from source if available; otherwise keep TOML version
    char available[256];
    if (strcmp(source, "Unknown") != 0) {
        char *tag = get_git_version_from_source(source);
        if (tag && strcmp(tag, "Unknown") != 0 && strcmp(tag, "moved-to-git") != 0) {
            strncpy(available, tag, sizeof(available));
            available[sizeof(available)-1] = '\0';
        } else {
            strncpy(available, version, sizeof(available));
            available[sizeof(available)-1] = '\0';
        }
    } else {
        strncpy(available, version, sizeof(available));
        available[sizeof(available)-1] = '\0';
    }

    printf("      Latest version available: %s\n", available);
    printf("      Latest version installed: %s\n", get_installed_version(package_name));
    printf("      Size of files: %s\n", get_package_size(package_name));
    printf("      Source:      %s\n", source);
    printf("      Description:   %s\n", description);
    printf("      License:       %s\n\n", license);
}

// Parse TOML content from string (for online packages)
void parse_package_info_from_content(const char *package_name, const char *toml_content) {
    if (!toml_content) {
        printf("      Latest version available: [ No metadata ]\n");
        printf("      Latest version installed: %s\n", get_installed_version(package_name));
        printf("      Size of files: %s\n", get_package_size(package_name));
        printf("      Source:      [ No metadata ]\n");
        printf("      Description:   [ No metadata ]\n");
        printf("      License:       [ No metadata ]\n\n");
        return;
    }
    
    char *content_copy = strdup(toml_content);
    char *line = strtok(content_copy, "\n");
    char version[128] = "Unknown";
    char source[256] = "Unknown";
    char description[512] = "No description available";
    char license[128] = "Unknown";
    
    while (line != NULL) {
        if (strncmp(line, "version = ", 10) == 0) {
            strcpy(version, line + 10);
            sanitize_value(version);
        } else if (strncmp(line, "source = ", 9) == 0) {
            strcpy(source, line + 9);
            sanitize_value(source);
        } else if (strncmp(line, "description = ", 13) == 0) {
            strcpy(description, line + 13);
            sanitize_value(description);
        } else if (strncmp(line, "license = ", 10) == 0) {
            strcpy(license, line + 10);
            sanitize_value(license);
        }
        line = strtok(NULL, "\n");
    }
    
    free(content_copy);

    // Prefer tag lookup from source if available; otherwise keep TOML version
    char available[256];
    if (strcmp(source, "Unknown") != 0) {
        char *tag = get_git_version_from_source(source);
        if (tag && strcmp(tag, "Unknown") != 0 && strcmp(tag, "moved-to-git") != 0) {
            strncpy(available, tag, sizeof(available));
            available[sizeof(available)-1] = '\0';
        } else {
            strncpy(available, version, sizeof(available));
            available[sizeof(available)-1] = '\0';
        }
    } else {
        strncpy(available, version, sizeof(available));
        available[sizeof(available)-1] = '\0';
    }

    printf("      Latest version available: %s\n", available);
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

// Enhanced search function that searches package name and description (for online packages)
int enhanced_search_online(const char *search_term, const char *package_name, const char *toml_content) {
    // First check if search term matches package name
    if (fuzzy_match(search_term, package_name)) {
        return 1;
    }
    
    // Then check if search term matches any content in TOML content
    if (!toml_content) {
        return 0;
    }
    
    char *content_copy = strdup(toml_content);
    char *line = strtok(content_copy, "\n");
    
    while (line != NULL) {
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
            free(content_copy);
            return 1;
        }
        
        line = strtok(NULL, "\n");
    }
    
    free(content_copy);
    return 0;
}

void searchScript(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: uspm s <search-term1> [search-term2] [search-term3] ...\n");
        printf("Example: uspm s python rust\n");
        return;
    }
    
    // Always search local repo (like before) - blazing fast!
    char repo_path[512];
    snprintf(repo_path, sizeof(repo_path), "%s/.local/share/uspm/repo", getenv("HOME"));
    
    DIR *dir = opendir(repo_path);
    if (!dir) {
        printf("Error: Could not open local repository directory\n");
        printf("Please run 'uspm u' to initialize the repository\n");
        return;
    }
    
    struct dirent *entry;
    int total_online_available = 0;
    
    // Display results for each search term
    for (int i = 2; i < argc; i++) {
        rewinddir(dir);
        int found_count = 0;
        
        printf("[ Results for search key : %s ]\n", argv[i]);
        printf("Searching local ...\n\n");
        
        // Search local repo (super fast like before)
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
        
        // If nothing found locally, quickly check online in background
        if (found_count == 0) {
            printf("No packages found matching '%s' in local repository\n", argv[i]);
            
            // Quick background check if available online
            if (quick_online_package_exists(argv[i])) {
                total_online_available++;
            }
        }
        
        printf("[ Applications found : %d ]\n", found_count);
        
        if (i < argc - 1) {
            printf("\n");
        }
    }
    
    closedir(dir);
    
    // Show professional orange notification if packages available online
    if (total_online_available > 0) {
        printf("\n\033[33m┌─────────────────────────────────────────────────────────────┐\033[0m\n");
        printf("\033[33m│   Online packages available for your search terms!         │\033[0m\n");
        printf("\033[33m│ Run 'uspm uu' to update your local repository               │\033[0m\n");
        printf("\033[33m│ Or use 'uspm os <package>' to search online directly        │\033[0m\n");
        printf("\033[33m└─────────────────────────────────────────────────────────────┘\033[0m\n");
    }
}
