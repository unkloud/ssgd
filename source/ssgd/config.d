module ssgd.config;

// Centralized configuration structure
struct SiteConfig
{
    // Path configurations
    string contentPath = "site/content/";
    string outputPath = "build/";
    string themePath = "site/";

    // Site metadata
    string siteName = "SSGD Site";
    string siteUrl = "/";
    string copyright = "Copyright © 2025";

    // Build settings
    int pagination = 20;

    // Server settings
    string serverPort = "8000";
    ushort httpPort = 8080;
    string[] bindAddresses = ["::1", "127.0.0.1"];

    // Static method to create default configuration
    static SiteConfig createDefault()
    {
        return SiteConfig();
    }

    // Method to create configuration from command line arguments
    static SiteConfig fromBuildArgs(string contentPath, string outputPath, string themePath,
            string siteName, string siteUrl, int pagination, string copyright = "Copyright © 2025")
    {
        SiteConfig config;
        config.contentPath = contentPath;
        config.outputPath = outputPath;
        config.themePath = themePath;
        config.siteName = siteName;
        config.siteUrl = siteUrl;
        config.pagination = pagination;
        config.copyright = copyright;
        return config;
    }

    // Method to create configuration for serving
    static SiteConfig fromServeArgs(string outputPath, string serverPort)
    {
        SiteConfig config;
        config.outputPath = outputPath;
        config.serverPort = serverPort;
        return config;
    }
}
