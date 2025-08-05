module ssgd.styles;

import std.file;
import std.path;
import std.string;

// Function to get default stylesheet content from template
string getDefaultStylesheet()
{
    string templatePath = buildPath(__FILE__.dirName, "..", "..", "..", "templates", "default_stylesheet.css");
    if (exists(templatePath))
    {
        return "  <style>\n    " ~ readText(templatePath).replace("\n", "\n    ") ~ "\n  </style>\n";
    }
    // Fallback if template file not found
    return getDefaultCSS();
}

// Function to get default CSS content from template
string getDefaultCSS()
{
    string templatePath = buildPath(__FILE__.dirName, "..", "..", "..", "templates", "default_stylesheet.css");
    if (exists(templatePath))
    {
        return readText(templatePath);
    }
    // Fallback CSS content
    return "body { font-family: sans-serif; }";
}

// Function to generate default stylesheet
void generateDefaultStylesheet(string path)
{
    string staticDir = buildPath(path, "site", "static");
    mkdirRecurse(staticDir);
    string cssPath = buildPath(staticDir, "style.css");
    std.file.write(cssPath, getDefaultCSS());
}
