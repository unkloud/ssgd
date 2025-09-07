module ssgd.generator;

import std.file;
import std.path;
import std.array;
import std.algorithm;
import std.string;
import std.stdio;
import ssgd.content;
import ssgd.renderer;
import ssgd.config;

void generateSite(SiteConfig config)
{
    auto collection = new PresentableContentCollection();
    auto markdownProcessor = new MarkdownProcessor();
    auto renderer = new HtmlRenderer(config.themePath, config.outputPath,
            config.siteName, config.siteUrl, config.copyright, Pagination(config.pagination));

    writeln("Loading content...");
    string postsPath = buildPath(config.contentPath, "posts");
    if (exists(postsPath) && isDir(postsPath))
    {
        foreach (string entry; dirEntries(postsPath, "*.md", SpanMode.shallow))
        {
            try
            {
                auto provider = new FileContentProvider(entry, "post");
                auto content = new PresentableContent(provider);
                collection.add(content);
                writeln("Loaded post: ", content.title);
            }
            catch (Exception e)
            {
                stderr.writeln("Error loading post: ", entry, " - ", e.msg);
            }
        }
    }
    string pagesPath = buildPath(config.contentPath, "pages");
    if (exists(pagesPath) && isDir(pagesPath))
    {
        foreach (string entry; dirEntries(pagesPath, "*.md", SpanMode.shallow))
        {
            try
            {
                auto provider = new FileContentProvider(entry, "page");
                auto content = new PresentableContent(provider);
                collection.add(content);
                writeln("Loaded page: ", content.title);
            }
            catch (Exception e)
            {
                stderr.writeln("Error loading page: ", entry, " - ", e.msg);
            }
        }
    }

    writeln("Processing markdown...");
    auto renderedCollection = markdownProcessor.processCollection(collection);
    writeln("Rendering site...");
    renderer.renderSite(renderedCollection);
    writeln("Site generation complete!");
}
