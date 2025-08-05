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
            return "<!DOCTYPE html>\n<html><head><title>{{title}}</title></head><body>{{content}}</body></html>";
        case "index.html":
            return "{{posts}}{{pagination}}";
        case "post.html":
            return "<h1>{{title}}</h1><div>{{content}}</div>";
        case "page.html":
            return "<h1>{{title}}</h1><div>{{content}}</div>";
        default:
            return "<div>Template not found</div>";
    }
}

// Function to generate templates
void generateTemplates(string path)
{
    std.file.write(buildPath(path, "site", "templates", "base.html"), getTemplateContent("base.html"));
    std.file.write(buildPath(path, "site", "templates", "index.html"), getTemplateContent("index.html"));
    std.file.write(buildPath(path, "site", "templates", "post.html"), getTemplateContent("post.html"));
    std.file.write(buildPath(path, "site", "templates", "page.html"), getTemplateContent("page.html"));
}
