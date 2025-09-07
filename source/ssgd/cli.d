module ssgd.cli;

import std.stdio;
import std.getopt;
import std.conv;
import std.file;
import ssgd.scaffolding;
import ssgd.generator;
import ssgd.config;
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
        writeln();
        writeln("Commands:");
        writeln("  init [path]                Initialize a new site");
        writeln("  build [options]            Build the site");
        writeln("  serve [options]            Serve the site locally");
        writeln("  help                       Show this help message");
        writeln("  version                    Show version information");
        writeln();
        writeln("Options for build:");
        writeln("  --content=PATH             Path to content directory (default: site/content)");
        writeln("  --output=PATH              Path to output directory (default: build)");
        writeln("  --theme=PATH               Theme to use (default: site)");
        writeln("  --name=NAME                Site name (default: SSGD Site)");
        writeln("  --url=URL                  Site URL (default: /)");
        writeln("  --pagination=NUM           Number of posts per page (default: 20)");
        writeln();
        writeln("Options for serve:");
        writeln("  --port=PORT                Port to serve on (default: 8000)");
        writeln("  --output=PATH              Path to output directory (default: build)");
    }

    int initCommand(string[] args)
    {
        return initSite(args);
    }

    int buildCommand(string[] args)
    {
        return buildSite(args);
    }

    int serveCommand(string[] args)
    {
        return serveSite(args);
    }
}

int buildSite(string[] args)
{
    auto config = SiteConfig.createDefault();
    string paginationStr = "20";
    try
    {
        if (args.length > 0)
        {
            string[] argsWithProgName = ["ssgd"] ~ args;
            getopt(argsWithProgName, "content", &config.contentPath, "output",
                &config.outputPath, "theme", &config.themePath, "name", &config.siteName,
                "url", &config.siteUrl, "pagination", &paginationStr);
        }
    }
    catch (Exception e)
    {
        stderr.writeln("Error parsing arguments: ", e.msg);
        return 1;
    }
    config.pagination = to!int(paginationStr);
    writeln("Building site from ", config.contentPath, " to ", config.outputPath);
    auto generator = new SiteGenerator(config);
    generator.generate();
    return 0;
}

int serveSite(string[] args)
{
    auto config = SiteConfig.createDefault();

    try
    {
        string[] argsWithProgName = ["ssgd"] ~ args;
        getopt(argsWithProgName, "port", &config.httpPort, "output", &config.outputPath);
    }
    catch (Exception e)
    {
        stderr.writeln("Error parsing arguments: ", e.msg);
        return 1;
    }

    if (!exists(config.outputPath))
    {
        stderr.writeln("Output directory does not exist: ", config.outputPath);
        stderr.writeln("Run 'ssgd build' first to generate the site.");
        return 1;
    }

    writeln("Serving site from ", config.outputPath, " on http://localhost:", config.httpPort);
    writeln("Press Ctrl+C to stop");

    auto settings = new HTTPServerSettings;
    settings.port = config.httpPort;
    settings.bindAddresses = config.bindAddresses;

    auto router = new URLRouter;
    router.get("*", serveStaticFiles(config.outputPath));

    auto listener = listenHTTP(settings, router);
    scope (exit)
    {
        listener.stopListening();
    }

    return runApplication(&args);
}
