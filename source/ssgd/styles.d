module ssgd.styles;

import std.file; // thisExePath, readText, exists
import std.path; // dirName, buildPath
import std.string; // replace

// Get default stylesheet as an inline <style> block from the executable's templates directory.
string getDefaultStylesheet()
{
    auto css = getDefaultCSS();
    return "  <style>\n    " ~ css.replace("\n", "\n    ") ~ "\n  </style>\n";
}

// Get default CSS content from the executable's templates directory.
// Throws if the template file is missing.
string getDefaultCSS()
{
    auto exeDir = thisExePath.dirName;
    string templatePath = buildPath(exeDir, "templates", "default_stylesheet.css");
    if (exists(templatePath))
    {
        return readText(templatePath);
    }
    throw new Exception("Default stylesheet template not found: " ~ templatePath ~
    ". Ensure 'templates/default_stylesheet.css' exists next to the executable.");
}

// Generate default stylesheet file into the site's static directory, using the template.
// Will throw if the template file does not exist.
void generateDefaultStylesheet(string path)
{
    string staticDir = buildPath(path, "site", "static");
    mkdirRecurse(staticDir);
    string cssPath = buildPath(staticDir, "style.css");
    std.file.write(cssPath, getDefaultCSS());
}
