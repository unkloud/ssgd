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
        return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{siteName}}</title>
  <link rel="stylesheet" href="https://unpkg.com/chota@latest">
  <link rel="stylesheet" href="/style.css">
</head>
<body>
  <header class="nav">
    <div class="container">
      <div class="nav-left">
        <a class="brand" href="{{siteUrl}}">{{siteName}}</a>
      </div>
    </div>
  </header>
  <main class="container">
    {{content}}
  </main>
  <footer class="container">
    <small>&copy; {{copyright}}</small>
  </footer>
</body>
</html>`;
    case "index.html":
        // Fragment inserted into base via {{content}}
        return `<section class="posts">
  {{posts}}
</section>
{{pagination}}`;
    case "post.html":
        return `<article class="card">
  <header><h1>{{title}}</h1></header>
  <div class="card-body content">{{content}}</div>
</article>`;
    case "page.html":
        return `<article class="card">
  <header><h1>{{title}}</h1></header>
  <div class="card-body content">{{content}}</div>
</article>`;
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
