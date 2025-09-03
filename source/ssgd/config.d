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
    ushort httpPort = 8000;
    string[] bindAddresses = ["::1", "127.0.0.1"];
    // Static method to create default configuration
    static SiteConfig createDefault()
    {
        return SiteConfig();
    }
}
