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

        // Create default templates
        std.file.write(buildPath(path, "site", "templates", "base.html"),
            "<!DOCTYPE html>\n" ~
                "<html lang=\"en\">\n" ~
                "<head>\n" ~
                "  <meta charset=\"utf-8\">\n" ~
                "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
                "  <title>{{title}}</title>\n" ~
                "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "  <div class=\"container\">\n" ~
                "    <header class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <nav class=\"nav\">\n" ~
                "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
                "          <div class=\"nav-right\">\n" ~
                "            <a href=\"/\">Home</a>\n" ~
                "            <a href=\"/about.html\">About</a>\n" ~
                "          </div>\n" ~
                "        </nav>\n" ~
                "      </div>\n" ~
                "    </header>\n" ~
                "    <main class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        {{content}}\n" ~
                "      </div>\n" ~
                "    </main>\n" ~
                "    <footer class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
                "      </div>\n" ~
                "    </footer>\n" ~
                "  </div>\n" ~
                "</body>\n" ~
                "</html>\n"
        );

        std.file.write(buildPath(path, "site", "templates", "index.html"),
            "<!DOCTYPE html>\n" ~
                "<html lang=\"en\">\n" ~
                "<head>\n" ~
                "  <meta charset=\"utf-8\">\n" ~
                "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
                "  <title>{{siteName}}</title>\n" ~
                "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "  <div class=\"container\">\n" ~
                "    <header class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <nav class=\"nav\">\n" ~
                "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
                "          <div class=\"nav-right\">\n" ~
                "            <a href=\"/\">Home</a>\n" ~
                "            <a href=\"/about.html\">About</a>\n" ~
                "          </div>\n" ~
                "        </nav>\n" ~
                "      </div>\n" ~
                "    </header>\n" ~
                "    <main class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <h2>Recent Posts</h2>\n" ~
                "        <div class=\"posts\">\n" ~
                "          {{posts}}\n" ~
                "        </div>\n" ~
                "      </div>\n" ~
                "    </main>\n" ~
                "    <footer class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
                "      </div>\n" ~
                "    </footer>\n" ~
                "  </div>\n" ~
                "</body>\n" ~
                "</html>\n"
        );

        std.file.write(buildPath(path, "site", "templates", "post.html"),
            "<!DOCTYPE html>\n" ~
                "<html lang=\"en\">\n" ~
                "<head>\n" ~
                "  <meta charset=\"utf-8\">\n" ~
                "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
                "  <title>{{title}} - {{siteName}}</title>\n" ~
                "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "  <div class=\"container\">\n" ~
                "    <header class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <nav class=\"nav\">\n" ~
                "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
                "          <div class=\"nav-right\">\n" ~
                "            <a href=\"/\">Home</a>\n" ~
                "            <a href=\"/about.html\">About</a>\n" ~
                "          </div>\n" ~
                "        </nav>\n" ~
                "      </div>\n" ~
                "    </header>\n" ~
                "    <main class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <article class=\"card\">\n" ~
                "          <header>\n" ~
                "            <h2>{{title}}</h2>\n" ~
                "            <p class=\"text-grey\"><small>Posted on {{date}} by {{author}}</small></p>\n" ~
                "          </header>\n" ~
                "          <div class=\"content\">\n" ~
                "            {{content}}\n" ~
                "          </div>\n" ~
                "        </article>\n" ~
                "      </div>\n" ~
                "    </main>\n" ~
                "    <footer class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
                "      </div>\n" ~
                "    </footer>\n" ~
                "  </div>\n" ~
                "</body>\n" ~
                "</html>\n"
        );

        std.file.write(buildPath(path, "site", "templates", "page.html"),
            "<!DOCTYPE html>\n" ~
                "<html lang=\"en\">\n" ~
                "<head>\n" ~
                "  <meta charset=\"utf-8\">\n" ~
                "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
                "  <title>{{title}} - {{siteName}}</title>\n" ~
                "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
                "</head>\n" ~
                "<body>\n" ~
                "  <div class=\"container\">\n" ~
                "    <header class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <nav class=\"nav\">\n" ~
                "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
                "          <div class=\"nav-right\">\n" ~
                "            <a href=\"/\">Home</a>\n" ~
                "            <a href=\"/about.html\">About</a>\n" ~
                "          </div>\n" ~
                "        </nav>\n" ~
                "      </div>\n" ~
                "    </header>\n" ~
                "    <main class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <article class=\"card page\">\n" ~
                "          <header>\n" ~
                "            <h2>{{title}}</h2>\n" ~
                "          </header>\n" ~
                "          <div class=\"content\">\n" ~
                "            {{content}}\n" ~
                "          </div>\n" ~
                "        </article>\n" ~
                "      </div>\n" ~
                "    </main>\n" ~
                "    <footer class=\"row\">\n" ~
                "      <div class=\"col\">\n" ~
                "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
                "      </div>\n" ~
                "    </footer>\n" ~
                "  </div>\n" ~
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
