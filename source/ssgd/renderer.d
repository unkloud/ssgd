module ssgd.renderer;

import std.file;
import std.path;
import std.array;
import std.algorithm;
import std.string;
import std.conv;
import std.datetime.date;
import std.regex;
import std.stdio;
import ssgd.content;
import ssgd.pagination;

class Renderer
{
    string themePath;
    string outputPath;
    string siteName;
    string siteUrl;
    string copyright;
    Pagination pagination;

    this(string themePath, string outputPath, string siteName = "SSGD Site",
            string siteUrl = "/", string copyright = "Copyright © 2025", Pagination pagination = Pagination(20))
    {
        this.themePath = themePath;
        this.outputPath = outputPath;
        this.siteName = siteName;
        this.siteUrl = siteUrl;
        this.copyright = copyright;
        this.pagination = pagination;
        if (!exists(outputPath))
        {
            mkdirRecurse(outputPath);
        }
    }

    string renderTemplate(string templatePath, string[string] vars)
    {
        if (!exists(templatePath))
        {
            throw new Exception("Template not found: " ~ templatePath);
        }
        string templateContent = readText(templatePath);
        return replaceTemplateVariables(templateContent, vars);
    }

    private string replaceTemplateVariables(string content, string[string] vars)
    {
        string result = content;
        foreach (key, value; vars)
        {
            string placeholder = "{{" ~ key ~ "}}";
            result = result.replace(placeholder, value);
        }
        return result;
    }

    void renderContent(Content content)
    {
        if (content is null)
        {
            throw new Exception("Cannot render null content");
        }
        string templateName = getTemplateName(content.contentType);
        string templatePath = buildPath(themePath, "templates", templateName);
        ensureOutputDirectory(content.url);
        string[string] vars = prepareContentVariables(content);
        try
        {
            string html = renderTemplate(templatePath, vars);
            string outputFile = buildPath(outputPath, content.url[1 .. $]);
            std.file.write(outputFile, html);
        }
        catch (Exception e)
        {
            throw new Exception("Failed to render content '" ~ content.title ~ "': " ~ e.msg);
        }
    }

    private string getTemplateName(string contentType)
    {
        return contentType == "post" ? "post.html" : "page.html";
    }

    private void ensureOutputDirectory(string url)
    {
        string outputDir = dirName(buildPath(outputPath, url[1 .. $]));
        if (!exists(outputDir))
        {
            mkdirRecurse(outputDir);
        }
    }

    private string[string] prepareContentVariables(Content content)
    {
        string[string] vars;
        vars["title"] = content.title ? content.title : "Untitled";
        vars["content"] = content.htmlContent ? content.htmlContent : "";
        vars["date"] = formatDate(content.date);
        vars["author"] = content.author ? content.author : "Unknown";
        vars["copyright"] = copyright;
        vars["siteName"] = siteName;
        vars["siteUrl"] = siteUrl;
        return vars;
    }

    private string formatDate(Date date)
    {
        return date.toISOExtString().split('T')[0];
    }

    void renderIndex(ContentCollection collection)
    {
        string templatePath = buildPath(themePath, "templates", "index.html");
        auto posts = collection.getPosts();
        posts.sort!((a, b) => a.date > b.date);
        int totalPosts = cast(int) posts.length;
        pagination.setTotalItems(totalPosts);
        for (int page = 1; page <= pagination.totalPages; page++)
        {
            pagination.setCurrentPage(page);
            string[string] vars;
            vars["title"] = siteName;
            vars["copyright"] = copyright;
            vars["siteName"] = siteName;
            vars["siteUrl"] = siteUrl;
            int startIndex = pagination.getStartIndex();
            int endIndex = pagination.getEndIndex();
            string postsHtml = "";
            for (int i = startIndex; i < endIndex; i++)
            {
                auto post = posts[i];
                postsHtml ~= "<div class=\"post-item\">\n";
                postsHtml ~= "  <h3 class=\"post-title\"><a href=\"" ~ post.url ~ "\">" ~ post.title ~ "</a></h3>\n";
                postsHtml ~= "  <div class=\"post-meta\">\n";
                postsHtml ~= "    <span>📅 " ~ formatDate(post.date) ~ "</span>\n";
                if (post.author && !post.author.empty)
                {
                    postsHtml ~= "    <span>✍️ " ~ post.author ~ "</span>\n";
                }
                postsHtml ~= "  </div>\n";
                string excerpt = post.getExcerpt();
                if (!excerpt.empty)
                {
                    postsHtml ~= "  <div class=\"post-excerpt\">" ~ excerpt ~ "</div>\n";
                }
                postsHtml ~= "  <a href=\"" ~ post.url ~ "\" class=\"read-more\">Read more →</a>\n";
                postsHtml ~= "</div>\n";
            }
            vars["posts"] = postsHtml;
            vars["pagination"] = pagination.generateHtml();
            string html = renderTemplate(templatePath, vars);
            string outputFile = buildPath(outputPath, pagination.getPageFilename());
            std.file.write(outputFile, html);
        }
    }

    void copyStaticFiles()
    {
        string themeStaticPath = buildPath(themePath, "static");
        if (exists(themeStaticPath))
        {
            foreach (string entry; dirEntries(themeStaticPath, SpanMode.breadth))
            {
                if (isFile(entry))
                {
                    string relativePath = entry[themeStaticPath.length + 1 .. $];
                    string outputFile = buildPath(outputPath, relativePath);
                    string outputDir = dirName(outputFile);
                    if (!exists(outputDir))
                    {
                        mkdirRecurse(outputDir);
                    }
                    copy(entry, outputFile);
                }
            }
        }
        string projectStaticPath = buildPath(themePath, "static");
        if (exists(projectStaticPath))
        {
            foreach (string entry; dirEntries(projectStaticPath, SpanMode.breadth))
            {
                if (isFile(entry))
                {
                    string relativePath = entry[themePath.length .. $];
                    string fileName = baseName(entry);
                    string outputFile;
                    // Rule 1: If file is robots.txt or favicon.ico, copy to build root
                    if (fileName == "robots.txt" || fileName == "favicon.ico")
                    {
                        outputFile = buildPath(outputPath, fileName);
                        copy(entry, outputFile);
                    }
                    else
                    {
                        // Rule 2: Mirror other files to build root (not build/static)
                        outputFile = buildPath(outputPath, relativePath);
                        string outputDir = dirName(outputFile);
                        if (!exists(outputDir))
                        {
                            mkdirRecurse(outputDir);
                        }
                        copy(entry, outputFile);
                    }
                }
            }
        }
    }

    void renderSite(ContentCollection collection)
    {
        foreach (content; collection.items)
        {
            renderContent(content);
        }
        renderIndex(collection);
        copyStaticFiles();
    }
}
