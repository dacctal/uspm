#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>
#include <time.h>

#define MAX_PACKAGES 100
#define MAX_PACKAGE_NAME 64
#define MAX_URL_LENGTH 512
#define MAX_TOML_CONTENT 4096
#define CACHE_EXPIRY_SECONDS 300  // 5 minutes

// Base URL for the online repository
static const char* BASE_URL = "https://raw.githubusercontent.com/dacctal/uspm/refs/heads/main/repo";

// Cache structure for package content
typedef struct {
    char package_name[MAX_PACKAGE_NAME];
    char content[MAX_TOML_CONTENT];
    time_t timestamp;
    int valid;
} PackageCache;

// Global cache array
static PackageCache package_cache[MAX_PACKAGES];
static int cache_initialized = 0;

// Initialize cache if not already done
void init_cache() {
    if (!cache_initialized) {
        for (int i = 0; i < MAX_PACKAGES; i++) {
            package_cache[i].valid = 0;
            package_cache[i].package_name[0] = '\0';
            package_cache[i].content[0] = '\0';
            package_cache[i].timestamp = 0;
        }
        cache_initialized = 1;
    }
}

// Check if cached content is still valid
int is_cache_valid(const PackageCache* cache_entry) {
    if (!cache_entry->valid) return 0;
    time_t now = time(NULL);
    return (now - cache_entry->timestamp) < CACHE_EXPIRY_SECONDS;
}

// Find package in cache
PackageCache* find_in_cache(const char* package_name) {
    init_cache();
    for (int i = 0; i < MAX_PACKAGES; i++) {
        if (package_cache[i].valid && 
            strcmp(package_cache[i].package_name, package_name) == 0 &&
            is_cache_valid(&package_cache[i])) {
            return &package_cache[i];
        }
    }
    return NULL;
}

// Add package to cache
void add_to_cache(const char* package_name, const char* content) {
    init_cache();
    
    // Find an empty slot or oldest entry
    int slot = -1;
    time_t oldest_time = time(NULL);
    
    for (int i = 0; i < MAX_PACKAGES; i++) {
        if (!package_cache[i].valid) {
            slot = i;
            break;
        }
        if (package_cache[i].timestamp < oldest_time) {
            oldest_time = package_cache[i].timestamp;
            slot = i;
        }
    }
    
    if (slot >= 0) {
        strncpy(package_cache[slot].package_name, package_name, MAX_PACKAGE_NAME - 1);
        package_cache[slot].package_name[MAX_PACKAGE_NAME - 1] = '\0';
        strncpy(package_cache[slot].content, content, MAX_TOML_CONTENT - 1);
        package_cache[slot].content[MAX_TOML_CONTENT - 1] = '\0';
        package_cache[slot].timestamp = time(NULL);
        package_cache[slot].valid = 1;
    }
}

// Fast direct content fetch using curl (like your friend's approach)
char* fetch_url_content_direct(const char* url) {
    char command[1024];
    static char content[MAX_TOML_CONTENT];
    
    // Use curl to directly fetch content without saving to disk
    snprintf(command, sizeof(command), 
             "curl -s --fail --max-time 5 \"%s\" 2>/dev/null", url);
    
    FILE* pipe = popen(command, "r");
    if (!pipe) {
        return NULL;
    }
    
    size_t bytes_read = fread(content, 1, sizeof(content) - 1, pipe);
    content[bytes_read] = '\0';
    
    int exit_code = pclose(pipe);
    
    // If curl failed or no content, return NULL
    if (exit_code != 0 || bytes_read == 0) {
        return NULL;
    }
    
    return content;
}

// Function to get list of available packages from online repo (faster, no HEAD requests)
int get_online_package_list(char packages[][MAX_PACKAGE_NAME], int max_packages) {
    // Use the known packages list - much faster than checking each one individually
    const char* known_packages[] = {
        "cairo", "cmake", "curl", "discord", "docker", "fastfetch", 
        "foot", "fuzzel", "gammastep", "gnu-coreutils", "llvm", 
        "make", "meson", "ninja", "otter-launcher", "pipes.sh", 
        "python", "rust", "unimatrix", "uspm", "waybar", "yad"
    };
    
    int count = 0;
    int known_count = sizeof(known_packages) / sizeof(known_packages[0]);
    
    // Just copy all known packages - we'll verify existence when fetching content
    for (int i = 0; i < known_count && count < max_packages; i++) {
        strncpy(packages[count], known_packages[i], MAX_PACKAGE_NAME - 1);
        packages[count][MAX_PACKAGE_NAME - 1] = '\0';
        count++;
    }
    
    return count;
}

// Function to get package.toml content from online repo (with caching)
char* get_online_package_toml(const char* package_name) {
    // Check cache first
    PackageCache* cached = find_in_cache(package_name);
    if (cached) {
        return cached->content;
    }
    
    // Not in cache or expired, fetch from online
    char package_url[MAX_URL_LENGTH];
    snprintf(package_url, sizeof(package_url), 
            "%s/%s/package.toml", BASE_URL, package_name);
    
    char* content = fetch_url_content_direct(package_url);
    
    // If successful, add to cache
    if (content && strlen(content) > 0) {
        add_to_cache(package_name, content);
        return content;
    }
    
    return NULL;
}

// Ultra-fast background check if package exists online (just HEAD request)
int quick_online_package_exists(const char* package_name) {
    char package_url[MAX_URL_LENGTH];
    char command[1024];
    
    snprintf(package_url, sizeof(package_url), 
            "%s/%s/package.toml", BASE_URL, package_name);
    
    // Ultra-fast HEAD request with 2 second timeout
    snprintf(command, sizeof(command), 
             "curl -s --head --fail --max-time 2 --connect-timeout 1 \"%s\" >/dev/null 2>&1", package_url);
    
    return system(command) == 0;
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
