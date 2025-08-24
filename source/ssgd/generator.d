module ssgd.generator;

import std.file;
import std.path;
import std.array;
import std.algorithm;
import std.string;
import std.stdio;
import ssgd.content;
import ssgd.markdown;
import ssgd.renderer;
import ssgd.config;
import ssgd.pagination;

class SiteGenerator
{
    SiteConfig config;
    ContentCollection collection;
    MarkdownProcessor markdownProcessor;
    Renderer renderer;

    this(SiteConfig config)
    {
        this.config = config;
        collection = new ContentCollection();
        markdownProcessor = new MarkdownProcessor();
        renderer = new Renderer(config.themePath, config.outputPath,
            config.siteName, config.siteUrl, config.copyright, Pagination(config.pagination));
    }

    void loadContent()
    {
        string postsPath = buildPath(config.contentPath, "posts");
        if (exists(postsPath) && isDir(postsPath))
        {
            foreach (string entry; dirEntries(postsPath, "*.md", SpanMode.shallow))
            {
                try
                {
                    auto content = new Content(entry, "post");
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
                    auto content = new Content(entry, "page");
                    collection.add(content);
                    writeln("Loaded page: ", content.title);
                }
                catch (Exception e)
                {
                    stderr.writeln("Error loading page: ", entry, " - ", e.msg);
                }
            }
        }
    }

    void processContent()
    {
        markdownProcessor.processCollection(collection);
    }

    void renderSite()
    {
        renderer.renderSite(collection);
    }

    void generate()
    {
        writeln("Loading content...");
        loadContent();
        writeln("Processing markdown...");
        processContent();
        writeln("Rendering site...");
        renderSite();
        writeln("Site generation complete!");
    }
}
