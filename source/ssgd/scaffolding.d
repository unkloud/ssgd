module ssgd.scaffolding;

import std.stdio;
import std.file;
import std.path;

// Sample content constants
immutable string HELLO_WORLD_CONTENT = "Title: Hello World\n" ~ "Date: 2025-01-01\n"
  ~ "Slug: hello-world\n" ~ "Author: SSGD User\n\n" ~ "# Hello World\n\n"
  ~ "This is a sample post created with SSGD, a static site generator written in D.\n\n"
  ~ "## Features\n\n" ~ "- Markdown support\n" ~ "- Simple theming\n"
  ~ "- Command-line interface similar to Pelican\n" ~ "- Static linking for easy distribution\n";

immutable string ABOUT_PAGE_CONTENT = "Title: About\n" ~ "Date: 2025-01-01\n"
  ~ "Slug: about\n" ~ "Author: SSGD User\n\n" ~ "# About SSGD\n\n"
  ~ "SSGD is a static site generator written in the D programming language.\n\n"
  ~ "This is a sample page created with SSGD.\n";

// Default robots.txt content
immutable string DEFAULT_ROBOTS_TXT = "User-agent: *\n" ~ "Disallow: /\n";

// Return empty default CSS (customization placeholder)
string getDefaultCSS()
{
  return ""; // intentionally empty; users can add overrides in site/static/style.css
}

// Functions to generate sample content and static files
void generateSampleContent(string path)
{
  auto postsDir = buildPath(path, "site", "content", "posts");
  auto pagesDir = buildPath(path, "site", "content", "pages");
  mkdirRecurse(postsDir);
  mkdirRecurse(pagesDir);
  std.file.write(buildPath(postsDir, "hello-world.md"), HELLO_WORLD_CONTENT);
  std.file.write(buildPath(pagesDir, "about.md"), ABOUT_PAGE_CONTENT);
}

void generateDefaultStaticFiles(string path)
{
  auto staticDir = buildPath(path, "site", "static");
  mkdirRecurse(staticDir);
  std.file.write(buildPath(staticDir, "robots.txt"), DEFAULT_ROBOTS_TXT);
}

// Generate empty stylesheet file into the site's static directory.
void generateDefaultStylesheet(string path)
{
  string staticDir = buildPath(path, "site", "static");
  mkdirRecurse(staticDir);
  string cssPath = buildPath(staticDir, "style.css");
  std.file.write(cssPath, getDefaultCSS());
}

// Function to get template content from file
string getTemplateContent(string templateName)
{
  string templatePath = buildPath(__FILE__.dirName, "..", "..", "..", "site",
    "templates", templateName);
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
    <section class="posts">
      {{posts}}
    </section>
    {{pagination}}
  </main>
  <footer class="container">
    <small>&copy; {{copyright}}</small>
  </footer>
</body>
</html>`;
    case "post.html":
      return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{title}} - {{siteName}}</title>
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
    <article class="card">
      <header><h1>{{title}}</h1></header>
      <div class="card-body content">{{content}}</div>
    </article>
  </main>
  <footer class="container">
    <small>&copy; {{copyright}}</small>
  </footer>
</body>
</html>`;
    case "page.html":
      return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{title}} - {{siteName}}</title>
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
    <article class="card">
      <header><h1>{{title}}</h1></header>
      <div class="card-body content">{{content}}</div>
    </article>
  </main>
  <footer class="container">
    <small>&copy; {{copyright}}</small>
  </footer>
</body>
</html>`;
    case "pagination.html":
      return `<nav class="pagination group">
  {{prevLink}}
  {{pageLinks}}
  {{nextLink}}
</nav>`;
    case "post_item.html":
      return `<article class="card post-item">
  <header><h3 class="post-title"><a href="{{url}}">{{title}}</a></h3></header>
  <div class="card-body">
    <p class="post-meta"><small>📅 {{date}} {{authorSpan}}</small></p>
    {{excerptDiv}}
    <a href="{{url}}" class="button primary is-small">Read more →</a>
  </div>
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
  std.file.write(buildPath(tplDir, "pagination.html"), getTemplateContent("pagination.html"));
  std.file.write(buildPath(tplDir, "post_item.html"), getTemplateContent("post_item.html"));
}

int initSite(string[] args)
{
  string path = ".";
  if (args.length > 0)
  {
    path = args[0];
  }

  writeln("Initializing new site in ", path);

  // Create directory structure
  mkdirRecurse(buildPath(path, "site", "content", "posts"));
  mkdirRecurse(buildPath(path, "site", "content", "pages"));
  mkdirRecurse(buildPath(path, "site", "templates"));

  writeln("Creating static folder: ", buildPath(path, "site", "static"));
  mkdirRecurse(buildPath(path, "site", "static"));
  mkdirRecurse(buildPath(path, "build"));

  // Generate sample content
  generateSampleContent(path);

  // Generate templates
  generateTemplates(path);

  // Generate static files
  writeln("Generating default static files...");
  generateDefaultStaticFiles(path);
  generateDefaultStylesheet(path);
  writeln("Static files generation complete.");

  writeln("Site initialized successfully!");
  writeln("Run 'ssgd build' to generate the site.");

  return 0;
}
