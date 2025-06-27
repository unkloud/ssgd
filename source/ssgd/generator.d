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

class SiteGenerator
{
    string contentPath;
    string outputPath;
    string themePath;
    string siteName;
    string siteUrl;
    string copyright;
    int pagination;
    ContentCollection collection;
    MarkdownProcessor markdownProcessor;
    Renderer renderer;

    this(string contentPath, string outputPath, string themePath,
        string siteName = "SSGD Site", string siteUrl = "/",
        int pagination = 20, string copyright = "Copyright © 2025")
    {
        this.contentPath = contentPath;
        this.outputPath = outputPath;
        this.themePath = themePath;
        this.siteName = siteName;
        this.siteUrl = siteUrl;
        this.pagination = pagination;
        this.copyright = copyright;
        collection = new ContentCollection();
        markdownProcessor = new MarkdownProcessor();
        renderer = new Renderer(themePath, outputPath, siteName, siteUrl, copyright, pagination);
    }

    void loadContent()
    {
        string postsPath = buildPath(contentPath, "posts");
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
        string pagesPath = buildPath(contentPath, "pages");
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
