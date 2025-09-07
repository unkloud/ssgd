module ssgd.renderer;

import std.file;
import std.path;
import std.array;
import std.algorithm;
import std.string;
import std.conv;
import std.datetime.date;
import commonmarkd;
import ssgd.content;

struct Pagination
{
    int itemsPerPage;
    int totalItems;
    int currentPage;
    int totalPages;

    this(int itemsPerPage)
    {
        this.itemsPerPage = itemsPerPage;
        this.totalItems = 0;
        this.currentPage = 1;
        this.totalPages = 1;
    }

    void setTotalItems(int total)
    {
        this.totalItems = total;
        this.totalPages = (total + itemsPerPage - 1) / itemsPerPage;
        if (totalPages == 0)
            totalPages = 1;
    }

    void setCurrentPage(int page)
    {
        // Clamp within valid range to avoid out-of-bounds when slicing posts
        if (totalPages < 1)
            totalPages = 1;
        if (page < 1)
            this.currentPage = 1;
        else if (page > totalPages)
            this.currentPage = totalPages;
        else
            this.currentPage = page;
    }

    int getStartIndex() const
    {
        return (currentPage - 1) * itemsPerPage;
    }

    int getEndIndex() const
    {
        int endIndex = getStartIndex() + itemsPerPage;
        if (endIndex > totalItems)
            endIndex = totalItems;
        return endIndex;
    }

    bool hasMultiplePages() const
    {
        return totalPages > 1;
    }

    string generateHtml(string themePath) const
    {
        if (!hasMultiplePages())
            return "";

        string templatePath = buildPath(themePath, "templates", "pagination.html");

        if (!exists(templatePath))
        {
            throw new Exception("Template not found: " ~ templatePath);
        }
        string templateContent = readText(templatePath);

        string prevLink = "";
        if (currentPage > 1)
        {
            string prevUrl = currentPage == 2 ? "index.html" : "page" ~ to!string(
                    currentPage - 1) ~ ".html";
            prevLink = "<a href=\"" ~ prevUrl ~ "\" class=\"button prev\">&laquo; Previous</a>";
        }

        string pageLinks = "";
        for (int p = 1; p <= totalPages; p++)
        {
            string pageUrl = p == 1 ? "index.html" : "page" ~ to!string(p) ~ ".html";
            string cls = (p == currentPage) ? "button primary" : "button outline";
            pageLinks ~= "  <a href=\"" ~ pageUrl ~ "\" class=\"" ~ cls ~ "\">" ~ to!string(
                    p) ~ "</a>\n";
        }

        string nextLink = "";
        if (currentPage < totalPages)
        {
            string nextUrl = "page" ~ to!string(currentPage + 1) ~ ".html";
            nextLink = "<a href=\"" ~ nextUrl ~ "\" class=\"button next\">Next &raquo;</a>";
        }

        templateContent = templateContent.replace("{{prevLink}}", prevLink);
        templateContent = templateContent.replace("{{pageLinks}}", pageLinks);
        templateContent = templateContent.replace("{{nextLink}}", nextLink);

        return templateContent;
    }

    string getPageFilename() const
    {
        return currentPage == 1 ? "index.html" : "page" ~ to!string(currentPage) ~ ".html";
    }
}

class HtmlRenderer
{
    string themePath;
    string outputPath;
    string siteName;
    string siteUrl;
    string copyright;
    Pagination pagination;

    this(string themePath, string outputPath, string siteName = "SSGD Site", string siteUrl = "/",
            string copyright = "Copyright © 2025", Pagination pagination = Pagination(20))
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

    void render(Content content)
    {
        assert(content !is null, "Cannot render null content");
        string templateName = getTemplateName(content.contentProvider.getSiteContentType());
        string templatePath = buildPath(themePath, "templates", templateName);
        ensureOutputDirectory(content.relativeUrl());
        string[string] vars = prepareContentVariables(content);
        try
        {
            string html = renderTemplate(templatePath, vars);
            string outputFile = buildPath(outputPath, content.relativeUrl()[1 .. $]);
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
        vars["content"] = content.renderedHtml ? content.renderedHtml : "";
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

    private string renderPostItem(Content post)
    {
        string templatePath = buildPath(themePath, "templates", "post_item.html");
        string[string] vars;
        vars["url"] = post.relativeUrl();
        vars["title"] = post.title ? post.title : "Untitled";
        vars["date"] = formatDate(post.date);
        vars["authorSpan"] = (post.author && !post.author.empty) ? "<span>✍️ "
            ~ post.author ~ "</span>" : "";
        string excerpt = post.getExcerpt();
        vars["excerptDiv"] = !excerpt.empty
            ? "<div class=\"post-excerpt\">" ~ convertMarkdownToHTML(excerpt) ~ "</div>" : "";
        if (!exists(templatePath))
        {
            throw new Exception("Template not found: " ~ templatePath);
        }
        string templateContent = readText(templatePath);
        return replaceTemplateVariables(templateContent, vars);
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
                postsHtml ~= renderPostItem(post);
            }
            vars["posts"] = postsHtml;
            vars["pagination"] = pagination.generateHtml(themePath);
            string html = renderTemplate(templatePath, vars);
            string outputFile = buildPath(outputPath, pagination.getPageFilename());
            std.file.write(outputFile, html);
        }
    }

    void copyStaticFiles()
    {
        // Copy files from <themePath>/static into output. Special-case robots.txt and favicon.ico to output root.
        string staticPath = buildPath(themePath, "static");
        if (!exists(staticPath))
            return;
        foreach (string entry; dirEntries(staticPath, SpanMode.breadth))
        {
            if (!isFile(entry))
                continue;
            string fileName = baseName(entry);
            // robots.txt and favicon.ico should be at site root
            if (fileName == "robots.txt" || fileName == "favicon.ico")
            {
                string rootTarget = buildPath(outputPath, fileName);
                copy(entry, rootTarget);
                continue;
            }
            // Everything else mirrors under output/static/...
            string relativeFromStatic = entry[staticPath.length + 1 .. $];
            string outputFile = buildPath(outputPath, relativeFromStatic);
            string outputDir = dirName(outputFile);
            if (!exists(outputDir))
            {
                mkdirRecurse(outputDir);
            }
            copy(entry, outputFile);
        }
    }

    void renderSite(ContentCollection collection)
    {
        foreach (content; collection.items)
        {
            render(content);
        }
        renderIndex(collection);
        copyStaticFiles();
    }
}
