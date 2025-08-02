module ssgd.serve;

import std.stdio;
import std.file;
import std.getopt;
import ssgd.config;
import vibe.http.server;
import vibe.http.fileserver;
import vibe.http.router;
import vibe.core.core;

int serveSite(string[] args)
{
    auto config = SiteConfig.createDefault();

    try
    {
        string[] argsWithProgName = ["ssgd"] ~ args;
        getopt(argsWithProgName, "port", &config.serverPort, "output", &config.outputPath);
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

    writeln("Serving site from ", config.outputPath, " on http://localhost:", config.serverPort);
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
