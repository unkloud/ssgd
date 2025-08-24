module ssgd.templates;

import std.file;
import std.path;

// Function to get template content from file
string getTemplateContent(string templateName)
{
    string templatePath = buildPath(__FILE__.dirName, "..", "..", "..", "site", "templates", templateName);
    if (exists(templatePath))
    {
        return readText(templatePath);
    }
    // Fallback content if template file not found
    return getDefaultTemplate(templateName);
}

// Fallback templates if files are not found
string getDefaultTemplate(string templateName)
{
    switch (templateName)
    {
    case "base.html":
        return "<!DOCTYPE html>\n" ~
            "<html lang=\"en\">\n" ~
            "<head>\n" ~
            "  <meta charset=\"utf-8\">\n" ~
            "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n" ~
            "  <title>{{siteName}}</title>\n" ~
            "  <link rel=\"stylesheet\" href=\"/style.css\">\n" ~
            "</head>\n" ~
            "<body>\n" ~
            "  <header><h1><a href=\"{{siteUrl}}\">{{siteName}}</a></h1></header>\n" ~
            "  <main>{{content}}</main>\n" ~
            "  <footer><small>{{copyright}}</small></footer>\n" ~
            "</body>\n" ~
            "</html>";
    case "index.html":
        // Fragment inserted into base via {{content}}
        return "<section class=\"posts\">{{posts}}</section>\n{{pagination}}";
    case "post.html":
        return "<article class=\"post\"><h1>{{title}}</h1><div class=\"content\">{{content}}</div></article>";
    case "page.html":
        return "<article class=\"page\"><h1>{{title}}</h1><div class=\"content\">{{content}}</div></article>";
    default:
        return "<div>Template not found</div>";
    }
}

// Function to generate templates
void generateTemplates(string path)
{
    auto tplDir = buildPath(path, "site", "templates");
    mkdirRecurse(tplDir);
    std.file.write(buildPath(tplDir, "base.html"), getTemplateContent("base.html"));
    std.file.write(buildPath(tplDir, "index.html"), getTemplateContent("index.html"));
    std.file.write(buildPath(tplDir, "post.html"), getTemplateContent("post.html"));
    std.file.write(buildPath(tplDir, "page.html"), getTemplateContent("page.html"));
}
