module ssgd.renderer;

import std.file;
import std.path;
import std.array;
import std.algorithm;
import std.string;
import std.conv;
import std.datetime.date;
import std.regex;
import ssgd.content;

class Renderer
{
    string themePath;
    string outputPath;
    string siteName;
    string siteUrl;
    string copyright;

    this(string themePath, string outputPath, string siteName = "SSGD Site",
        string siteUrl = "/", string copyright = "Copyright © 2025")
    {
        this.themePath = themePath;
        this.outputPath = outputPath;
        this.siteName = siteName;
        this.siteUrl = siteUrl;
        this.copyright = copyright;
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
        string[string] vars;
        vars["title"] = siteName;
        vars["copyright"] = copyright;
        vars["siteName"] = siteName;
        vars["siteUrl"] = siteUrl;
        string postsHtml = "";
        auto posts = collection.getPosts();
        posts.sort!((a, b) => a.date > b.date);
        foreach (post; posts)
        {
            postsHtml ~= "<li><a href=\"" ~ post.url ~ "\">" ~ post.title ~ "</a> ";
            postsHtml ~= "<span class=\"date\">" ~ post.date.toISOExtString()
                .split('T')[0] ~ "</span></li>\n";
        }
        vars["posts"] = postsHtml;
        string html = renderTemplate(templatePath, vars);
        string outputFile = buildPath(outputPath, "index.html");
        std.file.write(outputFile, html);
    }

    void copyStaticFiles()
    {
        string staticPath = buildPath(themePath, "static");
        if (!exists(staticPath))
        {
            return;
        }
        foreach (string entry; dirEntries(staticPath, SpanMode.breadth))
        {
            if (isFile(entry))
            {
                string relativePath = entry[staticPath.length + 1 .. $];
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
