module ssgd.cli;

import std.stdio;
import ssgd.init;
import ssgd.build;
import ssgd.serve;

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
