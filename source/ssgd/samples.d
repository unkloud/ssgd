module ssgd.samples;

import std.file;
import std.path;

// Sample content constants
immutable string HELLO_WORLD_CONTENT = "Title: Hello World\n" ~ "Date: 2025-01-01\n"
    ~ "Slug: hello-world\n" ~ "Author: SSGD User\n\n" ~ "# Hello World\n\n"
    ~ "This is a sample post created with SSGD, a static site generator written in D.\n\n"
    ~ "## Features\n\n" ~ "- Markdown support\n" ~ "- Simple theming\n"
    ~ "- Command-line interface similar to Pelican\n" ~ "- Static linking for easy distribution\n";

immutable string ABOUT_PAGE_CONTENT = "Title: About\n" ~ "Date: 2025-01-01\n"
    ~ "Slug: about\n" ~ "Author: SSGD User\n\n" ~ "# About SSGD\n\n"
    ~ "SSGD is a static site generator written in the D programming language.\n\n"
    ~ "This is a sample page created with SSGD.\n";

// Default robots.txt content
immutable string DEFAULT_ROBOTS_TXT = "User-agent: *\n" ~ "Disallow: /\n";

// Functions to generate sample content and static files
void generateSampleContent(string path)
{
    auto postsDir = buildPath(path, "site", "content", "posts");
    auto pagesDir = buildPath(path, "site", "content", "pages");
    mkdirRecurse(postsDir);
    mkdirRecurse(pagesDir);
    std.file.write(buildPath(postsDir, "hello-world.md"), HELLO_WORLD_CONTENT);
    std.file.write(buildPath(pagesDir, "about.md"), ABOUT_PAGE_CONTENT);
}

void generateDefaultStaticFiles(string path)
{
    auto staticDir = buildPath(path, "site", "static");
    mkdirRecurse(staticDir);
    std.file.write(buildPath(staticDir, "robots.txt"), DEFAULT_ROBOTS_TXT);
}
