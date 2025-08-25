module ssgd.styles;

import std.file; // write, exists
import std.path; // buildPath

// Return empty default CSS (customization placeholder)
string getDefaultCSS()
{
    return ""; // intentionally empty; users can add overrides in site/static/style.css
}

// Generate empty stylesheet file into the site's static directory.
void generateDefaultStylesheet(string path)
{
    string staticDir = buildPath(path, "site", "static");
    mkdirRecurse(staticDir);
    string cssPath = buildPath(staticDir, "style.css");
    std.file.write(cssPath, getDefaultCSS());
}
