void onlineSearchScript(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: uspm os <search-term1> [search-term2] [search-term3] ...\n");
        printf("Example: uspm os python rust\n");
        printf("Note: This searches the online repository directly (slower than local search)\n");
        return;
    }
    
    // Get the known packages list for online search
    char packages[MAX_PACKAGES][MAX_PACKAGE_NAME];
    int package_count = get_online_package_list(packages, MAX_PACKAGES);
    
    if (package_count == 0) {
        printf("Error: Could not connect to online repository\n");
        printf("Please check your internet connection\n");
        return;
    }
    
    // Display results for each search term
    for (int i = 2; i < argc; i++) {
        int found_count = 0;
        
        printf("[ Results for search key : %s ]\n", argv[i]);
        printf("Searching online ...\n\n");
        
        // Search through all online packages
        for (int j = 0; j < package_count; j++) {
            // Quick check if package name matches first (avoid downloading if not needed)
            if (fuzzy_match(argv[i], packages[j])) {
                char *toml_content = get_online_package_toml(packages[j]);
                printf("%s\n", packages[j]);
                parse_package_info_from_content(packages[j], toml_content);
                found_count++;
            } else {
                // Only download content if name doesn't match but we need to search description
                char *toml_content = get_online_package_toml(packages[j]);
                if (enhanced_search_online(argv[i], packages[j], toml_content)) {
                    printf("%s\n", packages[j]);
                    parse_package_info_from_content(packages[j], toml_content);
                    found_count++;
                }
            }
        }
        
        if (found_count == 0) {
            printf("No packages found matching '%s' in online repository\n", argv[i]);
        }
        
        printf("[ Applications found : %d ]\n", found_count);
        
        if (i < argc - 1) {
            printf("\n");
        }
    }
    
    printf("\n\033[36m  Tip: Run 'uspm uu' to sync these packages to your local repository for faster searches!\033[0m\n");
}
