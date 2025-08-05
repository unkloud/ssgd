module ssgd.pagination;

import std.conv;
import std.string;
import std.file;
import std.path;
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
        this.currentPage = page;
    }

    int getStartIndex()
    {
        return (currentPage - 1) * itemsPerPage;
    }

    int getEndIndex()
    {
        int endIndex = getStartIndex() + itemsPerPage;
        if (endIndex > totalItems)
            endIndex = totalItems;
        return endIndex;
    }

    bool hasMultiplePages()
    {
        return totalPages > 1;
    }

    string generateHtml()
    {
        if (!hasMultiplePages())
            return "";
        
        string templatePath = buildPath(__FILE__.dirName, "..", "..", "..", "templates", "pagination.html");
        if (!exists(templatePath))
        {
            // Fallback to original string concatenation if template not found
            string html = "<nav class=\"pagination\">\n";
            if (currentPage > 1)
            {
                string prevUrl = currentPage == 2 ? "index.html" : "page" ~ to!string(currentPage - 1) ~ ".html";
                html ~= "  <a href=\"" ~ prevUrl ~ "\" class=\"prev\">&laquo; Previous</a>\n";
            }
            for (int p = 1; p <= totalPages; p++)
            {
                string pageUrl = p == 1 ? "index.html" : "page" ~ to!string(p) ~ ".html";
                string activeClass = p == currentPage ? " class=\"active\"" : "";
                html ~= "  <a href=\"" ~ pageUrl ~ "\"" ~ activeClass ~ ">" ~ to!string(p) ~ "</a>\n";
            }
            if (currentPage < totalPages)
            {
                string nextUrl = "page" ~ to!string(currentPage + 1) ~ ".html";
                html ~= "  <a href=\"" ~ nextUrl ~ "\" class=\"next\">Next &raquo;</a>\n";
            }
            html ~= "</nav>\n";
            return html;
        }
        
        string prevLink = "";
        if (currentPage > 1)
        {
            string prevUrl = currentPage == 2 ? "index.html" : "page" ~ to!string(currentPage - 1) ~ ".html";
            prevLink = "<a href=\"" ~ prevUrl ~ "\" class=\"prev\">&laquo; Previous</a>";
        }
        
        string pageLinks = "";
        for (int p = 1; p <= totalPages; p++)
        {
            string pageUrl = p == 1 ? "index.html" : "page" ~ to!string(p) ~ ".html";
            string activeClass = p == currentPage ? " class=\"active\"" : "";
            pageLinks ~= "  <a href=\"" ~ pageUrl ~ "\"" ~ activeClass ~ ">" ~ to!string(p) ~ "</a>\n";
        }
        
        string nextLink = "";
        if (currentPage < totalPages)
        {
            string nextUrl = "page" ~ to!string(currentPage + 1) ~ ".html";
            nextLink = "<a href=\"" ~ nextUrl ~ "\" class=\"next\">Next &raquo;</a>";
        }
        
        string templateContent = readText(templatePath);
        templateContent = templateContent.replace("{{prevLink}}", prevLink);
        templateContent = templateContent.replace("{{pageLinks}}", pageLinks);
        templateContent = templateContent.replace("{{nextLink}}", nextLink);
        
        return templateContent;
    }

    string getPageFilename()
    {
        return currentPage == 1 ? "index.html" : "page" ~ to!string(currentPage) ~ ".html";
    }
}
