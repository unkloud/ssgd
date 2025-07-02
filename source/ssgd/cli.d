module ssgd.cli;

import std.stdio;
import std.file;
import std.path;
import std.string;
import std.getopt;
import std.conv;
import ssgd.generator;
import ssgd.defaults;
import vibe.http.server;
import vibe.http.fileserver;
import vibe.http.router;
import vibe.core.core;

enum VERSION = "0.0.1";

class CLI
{
    int run(string[] args)
    {
        if (args.length < 2)
        {
            printUsage();
            return 1;
        }
        string command = args[1];
        string[] commandArgs = args[2 .. $];
        switch (command)
        {
            case "init":
                return initCommand(commandArgs);
            case "build":
                return buildCommand(commandArgs);
            case "serve":
                return serveCommand(commandArgs);
            case "help":
                printUsage();
                return 0;
            case "version":
                writeln("SSGD version " ~ VERSION);
                return 0;
            default:
                writeln("Unknown command: ", command);
                printUsage();
                return 1;
        }
    }

    void printUsage()
    {
        writeln("SSGD - Static Site Generator in D");
        writeln("Usage: ssgd <command> [options]");
        writeln("");
        writeln("Commands:");
        writeln("  init [path]                Initialize a new site");
        writeln("  build [options]            Build the site");
        writeln("  serve [options]            Serve the site locally");
        writeln("  help                       Show this help message");
        writeln("  version                    Show version information");
        writeln("");
        writeln("Options for build:");
        writeln("  --content=PATH             Path to content directory (default: site/content)");
        writeln("  --output=PATH              Path to output directory (default: build)");
        writeln("  --theme=PATH               Theme to use (default: site)");
        writeln("  --name=NAME                Site name (default: SSGD Site)");
        writeln("  --url=URL                  Site URL (default: /)");
        writeln("  --pagination=NUM           Number of posts per page (default: 20)");
        writeln("");
        writeln("Options for serve:");
        writeln("  --port=PORT                Port to serve on (default: 8000)");
        writeln("  --output=PATH              Path to output directory (default: build)");
    }

    int initCommand(string[] args)
    {
        string path = ".";
        if (args.length > 0)
        {
            path = args[0];
        }
        writeln("Initializing new site in ", path);
        mkdirRecurse(buildPath(path, "site", "content", "posts"));
        mkdirRecurse(buildPath(path, "site", "content", "pages"));
        mkdirRecurse(buildPath(path, "site", "templates"));
        writeln("Creating static folder: ", buildPath(path, "site", "static"));
        mkdirRecurse(buildPath(path, "site", "static"));
        mkdirRecurse(buildPath(path, "build"));
        generateSampleContent(path);
        generateTemplates(path);
        writeln("Generating default static files...");
        generateDefaultStaticFiles(path);
        generateDefaultStylesheet(path);
        writeln("Static files generation complete.");
        writeln("Site initialized successfully!");
        writeln("Run 'ssgd build' to generate the site.");
        return 0;
    }

    int buildCommand(string[] args)
    {
        string contentPath = "site/content/";
        string outputPath = "build/";
        string themePath = "site/";
        string siteName = "SSGD Site";
        string siteUrl = "/";
        string paginationStr = "20";
        try
        {
            if (args.length > 0)
            {
                string[] argsWithProgName = ["ssgd"] ~ args;
                getopt(
                    argsWithProgName,
                    "content", &contentPath,
                    "output", &outputPath,
                    "theme", &themePath,
                    "name", &siteName,
                    "url", &siteUrl,
                    "pagination", &paginationStr
                );
            }
        }
        catch (Exception e)
        {
            stderr.writeln("Error parsing arguments: ", e.msg);
            return 1;
        }
        int pagination = to!int(paginationStr);
        writeln("Building site from ", contentPath, " to ", outputPath);
        auto generator = new SiteGenerator(
            contentPath,
            outputPath,
            themePath,
            siteName,
            siteUrl,
            pagination
        );
        generator.generate();
        return 0;
    }

    int serveCommand(string[] args)
    {
        string port = "8000";
        string outputPath = "build";
        try
        {
            string[] argsWithProgName = ["ssgd"] ~ args;
            getopt(
                argsWithProgName,
                "port", &port,
                "output", &outputPath
            );
        }
        catch (Exception e)
        {
            stderr.writeln("Error parsing arguments: ", e.msg);
            return 1;
        }
        if (!exists(outputPath))
        {
            stderr.writeln("Output directory does not exist: ", outputPath);
            stderr.writeln("Run 'ssgd build' first to generate the site.");
            return 1;
        }
        writeln("Serving site from ", outputPath, " on http://localhost:", port);
        writeln("Press Ctrl+C to stop");
        auto settings = new HTTPServerSettings;
        settings.port = 8080;
        settings.bindAddresses = ["::1", "127.0.0.1"];
        auto router = new URLRouter;
        router.get("*", serveStaticFiles(outputPath));
        auto listener = listenHTTP(settings, router);
        scope (exit)
        {
            listener.stopListening();
        }
        return runApplication(&args);
    }
}
