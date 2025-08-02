module ssgd.init;

import std.stdio;
import std.file;
import std.path;
import ssgd.templates;
import ssgd.styles;
import ssgd.samples;

int initSite(string[] args)
{
    string path = ".";
    if (args.length > 0)
    {
        path = args[0];
    }

    writeln("Initializing new site in ", path);

    // Create directory structure
    mkdirRecurse(buildPath(path, "site", "content", "posts"));
    mkdirRecurse(buildPath(path, "site", "content", "pages"));
    mkdirRecurse(buildPath(path, "site", "templates"));

    writeln("Creating static folder: ", buildPath(path, "site", "static"));
    mkdirRecurse(buildPath(path, "site", "static"));
    mkdirRecurse(buildPath(path, "build"));

    // Generate sample content
    generateSampleContent(path);

    // Generate templates
    generateTemplates(path);

    // Generate static files
    writeln("Generating default static files...");
    generateDefaultStaticFiles(path);
    generateDefaultStylesheet(path);
    writeln("Static files generation complete.");

    writeln("Site initialized successfully!");
    writeln("Run 'ssgd build' to generate the site.");

    return 0;
}
