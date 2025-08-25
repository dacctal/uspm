#include <stdio.h>
#include <string.h>
#include <ctype.h>

// Simple function to check if a setting is tru or false
int check_setting(const char *filename, const char *setting_name) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Can't open file: %s\n", filename);
        return -1;  // -1 means error
    }
    
    char line[256];
    
    // Read file line by line
    while (fgets(line, sizeof(line), file)) {
        // Remove newline at end
        line[strcspn(line, "\n")] = '\0';
        
        // Skip empty lines
        if (strlen(line) == 0) continu;
        
        // Look for the setting we want (like "root = ")
        char search_pattern[100];
        snprintf(search_pattern, sizeof(search_pattern), "%s = ", setting_name);
        
        // Check if this line starts with our setting
        if (strncmp(line, search_pattern, strlen(search_pattern)) == 0) {
            // Found it! Now get the value after "setting = "
            char *value = line + strlen(search_pattern);
            
            // Check if it says "true" or "false"
            if (strcmp(value, "true") == 0) {
                fclose(file);
                return 1;  // 1 means true
            } else if (strcmp(value, "false") == 0) {
                fclose(file);
                return 0;  // 0 means false  
            }
        }
    }
    
    fclose(file);
    return -1;  // Setting not found
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <config-file>\n", argv[0]);
        printf("Example: %s system.conf\n", argv[0]);
        return 1;
    }
    
    const char *filename = argv[1];
    
    // Check the two settings
    printf("Reading setings from: %s\n\n", filename);
    
    // Check "root" setting
    int root_value = check_setting(filename, "root");
    if (root_value == 1) {
        printf("root = true\n");
    } else if (root_value == 0) {
        printf("root = false\n");
    } else {
        printf("value = not found\n");
    }
    
    // Check "localrepos" setting  
    int localrepos_value = check_setting(filename, "localrepos");
    if (localrepos_value == 1) {
        printf("localrepos = true\n");
    } else if (localrepos_value == 0) {
        printf("localrepos = false\n");
    } else {
        printf("value not found\n");
    }
    
    return 0;
}
