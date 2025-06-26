module ssgd.cli;

import std.stdio;
import std.file;
import std.path;
import std.string;
import std.getopt;
import std.process;
import std.conv;
import ssgd.generator;

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
            writeln("SSGD version 1.0.0");
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
        mkdirRecurse(buildPath(path, "site", "static", "css"));
        mkdirRecurse(buildPath(path, "build"));
        std.file.write(buildPath(path, "site", "content", "posts", "hello-world.md"),
            "Title: Hello World\n" ~
                "Date: 2025-01-01\n" ~
                "Slug: hello-world\n" ~
                "Author: SSGD User\n\n" ~
                "# Hello World\n\n" ~
                "This is a sample post created with SSGD, a static site generator written in D.\n\n" ~
                "## Features\n\n" ~
                "- Markdown support\n" ~
                "- Simple theming\n" ~
                "- Command-line interface similar to Pelican\n" ~
                "- Static linking for easy distribution\n"
        );
        std.file.write(buildPath(path, "site", "content", "pages", "about.md"),
            "Title: About\n" ~
                "Date: 2025-01-01\n" ~
                "Slug: about\n" ~
                "Author: SSGD User\n\n" ~
                "# About SSGD\n\n" ~
                "SSGD is a static site generator written in the D programming language.\n\n" ~
                "This is a sample page created with SSGD.\n"
        );

        // Create default CSS
        std.file.write(buildPath(path, "site", "static", "css", "style.css"),
            "/* Basic styling for SSGD default theme */\n" ~
                "body {\n" ~
                "  font-family: -apple-system, BlinkMacSystemFont, \"Segoe UI\", Roboto, Helvetica, Arial, sans-serif;\n" ~
                "  line-height: 1.6;\n" ~
                "  color: #333;\n" ~
                "  max-width: 800px;\n" ~
                "  margin: 0 auto;\n" ~
                "  padding: 1rem;\n" ~
                "}\n\n" ~
                "header {\n" ~
                "  margin-bottom: 2rem;\n" ~
                "  border-bottom: 1px solid #eee;\n" ~
                "}\n\n" ~
                "a {\n" ~
                "  color: #0066cc;\n" ~
                "  text-decoration: none;\n" ~
                "}\n\n" ~
                "a:hover {\n" ~
                "  text-decoration: underline;\n" ~
                "}\n\n" ~
                ".posts {\n" ~
                "  list-style: none;\n" ~
                "  padding: 0;\n" ~
                "}\n\n" ~
                ".posts li {\n" ~
                "  margin-bottom: 1rem;\n" ~
                "}\n\n" ~
                ".date {\n" ~
                "  color: #666;\n" ~
                "  font-size: 0.9rem;\n" ~
                "  margin-left: 0.5rem;\n" ~
                "}\n\n" ~
                "footer {\n" ~
                "  margin-top: 2rem;\n" ~
                "  padding-top: 1rem;\n" ~
                "  border-top: 1px solid #eee;\n" ~
                "  color: #666;\n" ~
                "  font-size: 0.9rem;\n" ~
                "}\n"
        );

        // Create default templates
        std.file.write(buildPath(path, "site", "templates", "index.html"),
            "<!DOCTYPE html>\n" ~
                "<html>\n" ~
                "<head>\n" ~
                "    <title>{{title}}</title>\n" ~
                "    <link rel=\"stylesheet\" href=\"css/style.css\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "    <header>\n" ~
                "        <h1>{{siteName}}</h1>\n" ~
                "    </header>\n" ~
                "    <main>\n" ~
                "        <h2>Recent Posts</h2>\n" ~
                "        <ul class=\"posts\">\n" ~
                "            {{posts}}\n" ~
                "        </ul>\n" ~
                "    </main>\n" ~
                "    <footer>\n" ~
                "        <p>{{copyright}}</p>\n" ~
                "    </footer>\n" ~
                "</body>\n" ~
                "</html>\n"
        );

        std.file.write(buildPath(path, "site", "templates", "post.html"),
            "<!DOCTYPE html>\n" ~
                "<html>\n" ~
                "<head>\n" ~
                "    <title>{{title}} - {{siteName}}</title>\n" ~
                "    <link rel=\"stylesheet\" href=\"../css/style.css\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "    <header>\n" ~
                "        <h1><a href=\"../\">{{siteName}}</a></h1>\n" ~
                "    </header>\n" ~
                "    <main>\n" ~
                "        <article>\n" ~
                "            <h1>{{title}}</h1>\n" ~
                "            <div class=\"meta\">By {{author}} on {{date}}</div>\n" ~
                "            {{content}}\n" ~
                "        </article>\n" ~
                "    </main>\n" ~
                "    <footer>\n" ~
                "        <p>{{copyright}}</p>\n" ~
                "    </footer>\n" ~
                "</body>\n" ~
                "</html>\n"
        );

        std.file.write(buildPath(path, "site", "templates", "page.html"),
            "<!DOCTYPE html>\n" ~
                "<html>\n" ~
                "<head>\n" ~
                "    <title>{{title}} - {{siteName}}</title>\n" ~
                "    <link rel=\"stylesheet\" href=\"../css/style.css\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "    <header>\n" ~
                "        <h1><a href=\"../\">{{siteName}}</a></h1>\n" ~
                "    </header>\n" ~
                "    <main>\n" ~
                "        <article>\n" ~
                "            <h1>{{title}}</h1>\n" ~
                "            {{content}}\n" ~
                "        </article>\n" ~
                "    </main>\n" ~
                "    <footer>\n" ~
                "        <p>{{copyright}}</p>\n" ~
                "    </footer>\n" ~
                "</body>\n" ~
                "</html>\n"
        );

        writeln("Site initialized successfully!");
        writeln("Run 'ssgd build' to generate the site.");
        return 0;
    }

    int buildCommand(string[] args)
    {
        string contentPath = "site/content";
        string outputPath = "build";
        string themePath = "site";
        string siteName = "SSGD Site";
        string siteUrl = "/";
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
                    "url", &siteUrl
                );
            }
        }
        catch (Exception e)
        {
            stderr.writeln("Error parsing arguments: ", e.msg);
            return 1;
        }
        writeln("Building site from ", contentPath, " to ", outputPath);
        auto generator = new SiteGenerator(
            contentPath,
            outputPath,
            themePath,
            siteName,
            siteUrl
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
        writeln("Serving site from ", outputPath, " on http://localhost:", port);
        writeln("Press Ctrl+C to stop");
        auto pid = spawnProcess([
            "python", "-m", "http.server", port, "-d", outputPath
        ]);
        wait(pid);
        return 0;
    }
}
