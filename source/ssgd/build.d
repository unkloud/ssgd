module ssgd.build;

import std.stdio;
import std.getopt;
import std.conv;
import ssgd.generator;
import ssgd.config;

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
