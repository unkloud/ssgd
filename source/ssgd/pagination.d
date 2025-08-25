module ssgd.pagination;

import std.conv;
import std.string;
import std.file;
import std.path;

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

    string generateHtml() const
    {
        if (!hasMultiplePages())
            return "";

        string templatePath = buildPath(__FILE__.dirName, "..", "..", "..", "templates", "pagination.html");

        if (!exists(templatePath))
        {
            throw new Exception("Template not found: " ~ templatePath);
        }
        string templateContent = readText(templatePath);

        string prevLink = "";
        if (currentPage > 1)
        {
            string prevUrl = currentPage == 2 ? "index.html" : "page" ~ to!string(currentPage - 1) ~ ".html";
            prevLink = "<a href=\"" ~ prevUrl ~ "\" class=\"button prev\">&laquo; Previous</a>";
        }

        string pageLinks = "";
        for (int p = 1; p <= totalPages; p++)
        {
            string pageUrl = p == 1 ? "index.html" : "page" ~ to!string(p) ~ ".html";
            string cls = (p == currentPage) ? "button primary" : "button outline";
            pageLinks ~= "  <a href=\"" ~ pageUrl ~ "\" class=\"" ~ cls ~ "\">" ~ to!string(p) ~ "</a>\n";
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
