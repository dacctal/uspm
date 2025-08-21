#include <stdio.h>
#include <string.h>

// Returns latest tag version string for a repo source URL.
// Reads tags via:
// git ls-remote --tags <url> | sed -n 's|.*refs/tags/\(.*\)\^{}|\1|p; s|.*refs/tags/||p' | sort -V | tail -n 1
// If no version is found, returns "Unknown".
char* get_git_version_from_source(const char *source_url) {
    static char version[256];
    version[0] = '\0';

    if (source_url == NULL || source_url[0] == '\0' || strcmp(source_url, "Unknown") == 0) {
        strcpy(version, "Unknown");
        return version;
    }

    // Build URL with .git suffix if not present
    char url[512];
    if (strlen(source_url) >= 4 && strcmp(source_url + strlen(source_url) - 4, ".git") == 0) {
        snprintf(url, sizeof(url), "%s", source_url);
    } else {
        snprintf(url, sizeof(url), "%s.git", source_url);
    }

    // Build command pipeline
    char command[1024];
    snprintf(
        command,
        sizeof(command),
        "git ls-remote --tags '%s' | sed -n 's|.*refs/tags/\\(.*\\)\\^{}|\\1|p; s|.*refs/tags/||p' | sort -V | tail -n 1",
        url
    );

    FILE *pipe = popen(command, "r");
    if (!pipe) {
        strcpy(version, "Unknown");
        return version;
    }

    if (fgets(version, sizeof(version), pipe) != NULL) {
        version[strcspn(version, "\n")] = 0;
        if (version[0] == '\0') {
            strcpy(version, "Unknown");
        }
    } else {
        strcpy(version, "Unknown");
    }

    pclose(pipe);
    return version;
}


