module ssgd.defaults;

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

// Default stylesheet with shared styles
immutable string DEFAULT_STYLESHEET = "  <style>\n" ~ "    body {\n"
    ~ "      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;\n"
    ~ "      line-height: 1.7;\n" ~ "      color: #2c3e50;\n"
    ~ "      background-color: #fdfdfd;\n" ~ "    }\n" ~ "    \n" ~ "    .site-header {\n"
    ~ "      border-bottom: 1px solid #e8e8e8;\n"
    ~ "      background-color: #fff;\n"
    ~ "      padding: 1.5rem 0;\n"
    ~ "      margin-bottom: 3rem;\n"
    ~ "    }\n" ~ "    \n" ~ "    .site-title {\n" ~ "      font-size: 1.8rem;\n"
    ~ "      font-weight: 600;\n" ~ "      color: #2c3e50;\n" ~ "      text-decoration: none;\n"
    ~ "      letter-spacing: -0.02em;\n" ~ "    }\n" ~ "    \n"
    ~ "    .site-title:hover {\n"
    ~ "      color: #3498db;\n" ~ "      text-decoration: none;\n"
    ~ "    }\n" ~ "    \n" ~ "    .site-nav {\n" ~ "      display: flex;\n"
    ~ "      justify-content: space-between;\n" ~ "      align-items: center;\n"
    ~ "      max-width: 800px;\n" ~ "      margin: 0 auto;\n"
    ~ "      padding: 0 1rem;\n" ~ "    }\n" ~ "    \n" ~ "    .nav-links a {\n"
    ~ "      margin-left: 2rem;\n"
    ~ "      color: #7f8c8d;\n" ~ "      text-decoration: none;\n"
    ~ "      font-weight: 500;\n" ~ "      transition: color 0.2s ease;\n"
    ~ "    }\n" ~ "    \n" ~ "    .nav-links a:hover {\n" ~ "      color: #2c3e50;\n"
    ~ "    }\n" ~ "    \n" ~ "    .main-content {\n" ~ "      max-width: 800px;\n"
    ~ "      margin: 0 auto;\n"
    ~ "      padding: 0 1rem;\n"
    ~ "      min-height: calc(100vh - 200px);\n" ~ "    }\n" ~ "    \n"
    ~ "    .site-footer {\n" ~ "      border-top: 1px solid #e8e8e8;\n"
    ~ "      background-color: #f8f9fa;\n" ~ "      padding: 2rem 0;\n"
    ~ "      margin-top: 4rem;\n" ~ "      text-align: center;\n" ~ "    }\n"
    ~ "    \n" ~ "    .footer-content {\n" ~ "      max-width: 800px;\n"
    ~ "      margin: 0 auto;\n" ~ "      padding: 0 1rem;\n" ~ "      color: #7f8c8d;\n"
    ~ "      font-size: 0.9rem;\n" ~ "    }\n" ~ "    \n"
    ~ "    /* Typography improvements */\n" ~ "    h1, h2, h3, h4, h5, h6 {\n"
    ~ "      color: #2c3e50;\n" ~ "      font-weight: 600;\n"
    ~ "      line-height: 1.3;\n" ~ "      margin-top: 2rem;\n"
    ~ "      margin-bottom: 1rem;\n"
    ~ "    }\n" ~ "    \n" ~ "    h1 { font-size: 2.2rem; }\n"
    ~ "    h2 { font-size: 1.8rem; }\n" ~ "    h3 { font-size: 1.4rem; }\n" ~ "    \n"
    ~ "    p {\n" ~ "      margin-bottom: 1.5rem;\n" ~ "    }\n" ~ "    \n"
    ~ "    /* Content spacing */\n" ~ "    .content-wrapper {\n"
    ~ "      margin-bottom: 2rem;\n" ~ "    }\n" ~ "  </style>\n";

// Template constants
immutable string BASE_TEMPLATE = "<!DOCTYPE html>\n" ~ "<html lang=\"en\">\n" ~ "<head>\n" ~ "  <meta charset=\"utf-8\">\n" ~ "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~ "  <title>{{title}}</title>\n" ~ "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~ "  <link rel=\"stylesheet\" href=\"/static/style.css\">\n" ~ "</head>\n" ~ "<body>\n" ~ "  <header class=\"site-header\">\n" ~ "    <nav class=\"site-nav\">\n" ~ "      <a href=\"/\" class=\"site-title\">{{siteName}}</a>\n" ~ "      <div class=\"nav-links\">\n" ~ "        <a href=\"/\">Home</a>\n" ~ "        <a href=\"/about.html\">About</a>\n" ~ "      </div>\n" ~ "    </nav>\n" ~ "  </header>\n" ~ "  \n" ~ "  <main class=\"main-content\">\n" ~ "    <div class=\"content-wrapper\">\n" ~ "      {{content}}\n" ~ "    </div>\n" ~ "  </main>\n" ~ "  \n" ~ "  <footer class=\"site-footer\">\n" ~ "    <div class=\"footer-content\">\n" ~ "      <p>&copy; {{copyright}}</p>\n" ~ "    </div>\n" ~ "  </footer>\n" ~ "</body>\n" ~ "</html>\n";

immutable string INDEX_TEMPLATE = "<!DOCTYPE html>\n" ~ "<html lang=\"en\">\n" ~ "<head>\n" ~ "  <meta charset=\"utf-8\">\n" ~ "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~ "  <title>{{siteName}}</title>\n" ~ "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~ "  <link rel=\"stylesheet\" href=\"/static/style.css\">\n" ~ "  <style>\n" ~ "    /* Posts list styling */\n" ~ "    .posts-section {\n" ~ "      margin-bottom: 3rem;\n" ~ "    }\n" ~ "    \n" ~ "    .posts-title {\n" ~ "      font-size: 1.6rem;\n" ~ "      margin-bottom: 2rem;\n" ~ "      color: #2c3e50;\n" ~ "      border-bottom: 2px solid #e8e8e8;\n" ~ "      padding-bottom: 0.5rem;\n" ~ "    }\n" ~ "    \n" ~ "    .posts-list {\n" ~ "      list-style: none;\n" ~ "      padding: 0;\n" ~ "    }\n" ~ "    \n" ~ "    .post-item {\n" ~ "      margin-bottom: 2rem;\n" ~ "      padding-bottom: 1.5rem;\n" ~ "      border-bottom: 1px solid #f0f0f0;\n" ~ "    }\n" ~ "    \n" ~ "    .post-item:last-child {\n" ~ "      border-bottom: none;\n" ~ "    }\n" ~ "    \n" ~ "    .post-title {\n" ~ "      font-size: 1.3rem;\n" ~ "      margin-bottom: 0.5rem;\n" ~ "    }\n" ~ "    \n" ~ "    .post-title a {\n" ~ "      color: #2c3e50;\n" ~ "      text-decoration: none;\n" ~ "      transition: color 0.2s ease;\n" ~ "    }\n" ~ "    \n" ~ "    .post-title a:hover {\n" ~ "      color: #3498db;\n" ~ "    }\n" ~ "    \n" ~ "    .post-meta {\n" ~ "      color: #7f8c8d;\n" ~ "      font-size: 0.9rem;\n" ~ "      margin-bottom: 0.8rem;\n" ~ "    }\n" ~ "    \n" ~ "    .post-excerpt {\n" ~ "      color: #555;\n" ~ "      line-height: 1.6;\n" ~ "    }\n" ~ "  </style>\n" ~ "</head>\n" ~ "<body>\n" ~ "  <header class=\"site-header\">\n" ~ "    <nav class=\"site-nav\">\n" ~ "      <a href=\"/\" class=\"site-title\">{{siteName}}</a>\n" ~ "      <div class=\"nav-links\">\n" ~ "        <a href=\"/\">Home</a>\n" ~ "        <a href=\"/about.html\">About</a>\n" ~ "      </div>\n" ~ "    </nav>\n" ~ "  </header>\n" ~ "  \n" ~ "  <main class=\"main-content\">\n" ~ "    <div class=\"content-wrapper\">\n" ~ "      <section class=\"posts-section\">\n" ~ "        <h2 class=\"posts-title\">Recent Posts</h2>\n" ~ "        <div class=\"posts-list\">\n" ~ "          {{posts}}\n" ~ "        </div>\n" ~ "      </section>\n" ~ "    </div>\n" ~ "  </main>\n" ~ "  \n" ~ "  <footer class=\"site-footer\">\n" ~ "    <div class=\"footer-content\">\n" ~ "      <p>&copy; {{copyright}}</p>\n" ~ "    </div>\n" ~ "  </footer>\n" ~ "</body>\n" ~ "</html>\n";

immutable string POST_TEMPLATE = "<!DOCTYPE html>\n" ~ "<html lang=\"en\">\n" ~ "<head>\n" ~ "  <meta charset=\"utf-8\">\n" ~ "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~ "  <title>{{title}} - {{siteName}}</title>\n" ~ "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~ "  <link rel=\"stylesheet\" href=\"/static/style.css\">\n" ~ "  <style>\n" ~ "    /* Article styling */\n" ~ "    .article {\n" ~ "      background-color: #fff;\n" ~ "      border-radius: 8px;\n" ~ "      box-shadow: 0 2px 4px rgba(0,0,0,0.1);\n" ~ "      padding: 3rem;\n" ~ "      margin-bottom: 3rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-header {\n" ~ "      margin-bottom: 2rem;\n" ~ "      padding-bottom: 1.5rem;\n" ~ "      border-top: 1px solid #e8e8e8;\n" ~ "    }\n" ~ "    \n" ~ "    .article-title {\n" ~ "      font-size: 2.2rem;\n" ~ "      font-weight: 700;\n" ~ "      color: #2c3e50;\n" ~ "      margin-bottom: 1rem;\n" ~ "      line-height: 1.2;\n" ~ "    }\n" ~ "    \n" ~ "    .article-meta {\n" ~ "      color: #7f8c8d;\n" ~ "      font-size: 0.95rem;\n" ~ "      display: flex;\n" ~ "      gap: 1rem;\n" ~ "      align-items: center;\n" ~ "    }\n" ~ "    \n" ~ "    .article-meta span {\n" ~ "      display: flex;\n" ~ "      align-items: center;\n" ~ "      gap: 0.3rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content {\n" ~ "      font-size: 1.1rem;\n" ~ "      line-height: 1.8;\n" ~ "      color: #2c3e50;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content h2 {\n" ~ "      margin-top: 2.5rem;\n" ~ "      margin-bottom: 1rem;\n" ~ "      font-size: 1.6rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content h3 {\n" ~ "      margin-top: 2rem;\n" ~ "      margin-bottom: 0.8rem;\n" ~ "      font-size: 1.3rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content p {\n" ~ "      margin-bottom: 1.5rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content ul, .article-content ol {\n" ~ "      margin-bottom: 1.5rem;\n" ~ "      padding-left: 2rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content li {\n" ~ "      margin-bottom: 0.5rem;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content blockquote {\n" ~ "      border-left: 4px solid #3498db;\n" ~ "      padding-left: 1.5rem;\n" ~ "      margin: 2rem 0;\n" ~ "      font-style: italic;\n" ~ "      color: #555;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content code {\n" ~ "      background-color: #f8f9fa;\n" ~ "      padding: 0.2rem 0.4rem;\n" ~ "      border-radius: 3px;\n" ~ "      font-size: 0.9em;\n" ~ "    }\n" ~ "    \n" ~ "    .article-content pre {\n" ~ "      background-color: #f8f9fa;\n" ~ "      padding: 1rem;\n" ~ "      border-radius: 5px;\n" ~ "      overflow-x: auto;\n" ~ "      margin: 1.5rem 0;\n" ~ "    }\n" ~ "    \n" ~ "    /* Navigation breadcrumb */\n" ~ "    .breadcrumb {\n" ~ "      margin-bottom: 2rem;\n" ~ "      font-size: 0.9rem;\n" ~ "    }\n" ~ "    \n" ~ "    .breadcrumb a {\n" ~ "      color: #7f8c8d;\n" ~ "      text-decoration: none;\n" ~ "    }\n" ~ "    \n" ~ "    .breadcrumb a:hover {\n" ~ "      color: #2c3e50;\n" ~ "    }\n" ~ "  </style>\n" ~ "</head>\n" ~ "<body>\n" ~ "  <header class=\"site-header\">\n" ~ "    <nav class=\"site-nav\">\n" ~ "      <a href=\"/\" class=\"site-title\">{{siteName}}</a>\n" ~ "      <div class=\"nav-links\">\n" ~ "        <a href=\"/\">Home</a>\n" ~ "        <a href=\"/about.html\">About</a>\n" ~ "      </div>\n" ~ "    </nav>\n" ~ "  </header>\n" ~ "  \n" ~ "  <main class=\"main-content\">\n" ~ "    <div class=\"content-wrapper\">\n" ~ "      <nav class=\"breadcrumb\">\n" ~ "        <a href=\"/\">Home</a> / {{title}}\n" ~ "      </nav>\n" ~ "      \n" ~ "      <article class=\"article\">\n" ~ "        <header class=\"article-header\">\n" ~ "          <h1 class=\"article-title\">{{title}}</h1>\n" ~ "          <div class=\"article-meta\">\n" ~ "            <span>📅 {{date}}</span>\n" ~ "            <span>✍️ {{author}}</span>\n" ~ "          </div>\n" ~ "        </header>\n" ~ "        \n" ~ "        <div class=\"article-content\">\n" ~ "          {{content}}\n" ~ "        </div>\n" ~ "      </article>\n" ~ "    </div>\n" ~ "  </main>\n" ~ "  \n" ~ "  <footer class=\"site-footer\">\n" ~ "    <div class=\"footer-content\">\n" ~ "      <p>&copy; {{copyright}}</p>\n" ~ "    </div>\n" ~ "  </footer>\n" ~ "</body>\n" ~ "</html>\n";

immutable string PAGE_TEMPLATE = "<!DOCTYPE html>\n" ~ "<html lang=\"en\">\n" ~ "<head>\n" ~ "  <meta charset=\"utf-8\">\n" ~ "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~ "  <title>{{title}} - {{siteName}}</title>\n" ~ "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~ "  <link rel=\"stylesheet\" href=\"/static/style.css\">\n" ~ "  <style>\n" ~ "    /* Page styling */\n" ~ "    .page {\n" ~ "      background-color: #fff;\n" ~ "      border-radius: 8px;\n" ~ "      box-shadow: 0 2px 4px rgba(0,0,0,0.1);\n" ~ "      padding: 3rem;\n" ~ "      margin-bottom: 3rem;\n" ~ "    }\n" ~ "    \n" ~ "    .page-header {\n" ~ "      margin-bottom: 2rem;\n" ~ "      padding-bottom: 1.5rem;\n" ~ "      border-bottom: 1px solid #e8e8e8;\n" ~ "    }\n" ~ "    \n" ~ "    .page-title {\n" ~ "      font-size: 2.2rem;\n" ~ "      font-weight: 700;\n" ~ "      color: #2c3e50;\n" ~ "      margin-bottom: 0;\n" ~ "      line-height: 1.2;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content {\n" ~ "      font-size: 1.1rem;\n" ~ "      line-height: 1.8;\n" ~ "      color: #2c3e50;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content h2 {\n" ~ "      margin-top: 2.5rem;\n" ~ "      margin-bottom: 1rem;\n" ~ "      font-size: 1.6rem;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content h3 {\n" ~ "      margin-top: 2rem;\n" ~ "      margin-bottom: 0.8rem;\n" ~ "      font-size: 1.3rem;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content p {\n" ~ "      margin-bottom: 1.5rem;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content ul, .page-content ol {\n" ~ "      margin-bottom: 1.5rem;\n" ~ "      padding-left: 2rem;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content li {\n" ~ "      margin-bottom: 0.5rem;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content blockquote {\n" ~ "      border-left: 4px solid #3498db;\n" ~ "      padding-left: 1.5rem;\n" ~ "      margin: 2rem 0;\n" ~ "      font-style: italic;\n" ~ "      color: #555;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content code {\n" ~ "      background-color: #f8f9fa;\n" ~ "      padding: 0.2rem 0.4rem;\n" ~ "      border-radius: 3px;\n" ~ "      font-size: 0.9em;\n" ~ "    }\n" ~ "    \n" ~ "    .page-content pre {\n" ~ "      background-color: #f8f9fa;\n" ~ "      padding: 1rem;\n" ~ "      border-radius: 5px;\n" ~ "      overflow-x: auto;\n" ~ "      margin: 1.5rem 0;\n" ~ "    }\n" ~ "    \n" ~ "    /* Navigation breadcrumb */\n" ~ "    .breadcrumb {\n" ~ "      margin-bottom: 2rem;\n" ~ "      font-size: 0.9rem;\n" ~ "    }\n" ~ "    \n" ~ "    .breadcrumb a {\n" ~ "      color: #7f8c8d;\n" ~ "      text-decoration: none;\n" ~ "    }\n" ~ "    \n" ~ "    .breadcrumb a:hover {\n" ~ "      color: #2c3e50;\n" ~ "    }\n" ~ "  </style>\n" ~ "</head>\n" ~ "<body>\n" ~ "  <header class=\"site-header\">\n" ~ "    <nav class=\"site-nav\">\n" ~ "      <a href=\"/\" class=\"site-title\">{{siteName}}</a>\n" ~ "      <div class=\"nav-links\">\n" ~ "        <a href=\"/\">Home</a>\n" ~ "        <a href=\"/about.html\">About</a>\n" ~ "      </div>\n" ~ "    </nav>\n" ~ "  </header>\n" ~ "  \n" ~ "  <main class=\"main-content\">\n" ~ "    <div class=\"content-wrapper\">\n" ~ "      <nav class=\"breadcrumb\">\n" ~ "        <a href=\"/\">Home</a> / {{title}}\n" ~ "      </nav>\n" ~ "      \n" ~ "      <article class=\"page\">\n" ~ "        <header class=\"page-header\">\n" ~ "          <h1 class=\"page-title\">{{title}}</h1>\n" ~ "        </header>\n" ~ "        \n" ~ "        <div class=\"page-content\">\n" ~ "          {{content}}\n" ~ "        </div>\n" ~ "      </article>\n" ~ "    </div>\n" ~ "  </main>\n" ~ "  \n" ~ "  <footer class=\"site-footer\">\n" ~ "    <div class=\"footer-content\">\n" ~ "      <p>&copy; {{copyright}}</p>\n" ~ "    </div>\n" ~ "  </footer>\n" ~ "</body>\n" ~ "</html>\n";

// Default stylesheet as CSS file content (without <style> tags)
immutable string DEFAULT_CSS = "body {\n"
    ~ "  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;\n"
    ~ "  line-height: 1.7;\n" ~ "  color: #2c3e50;\n" ~ "  background-color: #fdfdfd;\n"
    ~ "}\n" ~ "\n" ~ ".site-header {\n" ~ "  border-bottom: 1px solid #e8e8e8;\n"
    ~ "  background-color: #fff;\n"
    ~ "  padding: 1.5rem 0;\n" ~ "  margin-bottom: 3rem;\n" ~ "}\n"
    ~ "\n" ~ ".site-title {\n" ~ "  font-size: 1.8rem;\n" ~ "  font-weight: 600;\n"
    ~ "  color: #2c3e50;\n" ~ "  text-decoration: none;\n"
    ~ "  letter-spacing: -0.02em;\n" ~ "}\n" ~ "\n" ~ ".site-title:hover {\n"
    ~ "  color: #3498db;\n" ~ "  text-decoration: none;\n" ~ "}\n" ~ "\n"
    ~ ".site-nav {\n" ~ "  display: flex;\n" ~ "  justify-content: space-between;\n"
    ~ "  align-items: center;\n" ~ "  max-width: 800px;\n" ~ "  margin: 0 auto;\n"
    ~ "  padding: 0 1rem;\n" ~ "}\n" ~ "\n" ~ ".nav-links a {\n"
    ~ "  margin-left: 2rem;\n" ~ "  color: #7f8c8d;\n" ~ "  text-decoration: none;\n"
    ~ "  font-weight: 500;\n" ~ "  transition: color 0.2s ease;\n" ~ "}\n" ~ "\n"
    ~ ".nav-links a:hover {\n" ~ "  color: #2c3e50;\n" ~ "}\n" ~ "\n"
    ~ ".main-content {\n" ~ "  max-width: 800px;\n" ~ "  margin: 0 auto;\n"
    ~ "  padding: 0 1rem;\n" ~ "  min-height: calc(100vh - 200px);\n"
    ~ "}\n" ~ "\n" ~ ".site-footer {\n" ~ "  border-top: 1px solid #e8e8e8;\n"
    ~ "  background-color: #f8f9fa;\n" ~ "  padding: 2rem 0;\n"
    ~ "  margin-top: 4rem;\n" ~ "  text-align: center;\n" ~ "}\n" ~ "\n"
    ~ ".footer-content {\n" ~ "  max-width: 800px;\n" ~ "  margin: 0 auto;\n"
    ~ "  padding: 0 1rem;\n" ~ "  color: #7f8c8d;\n" ~ "  font-size: 0.9rem;\n" ~ "}\n"
    ~ "\n" ~ "/* Typography improvements */\n" ~ "h1, h2, h3, h4, h5, h6 {\n"
    ~ "  color: #2c3e50;\n" ~ "  font-weight: 600;\n" ~ "  line-height: 1.3;\n"
    ~ "  margin-top: 2rem;\n" ~ "  margin-bottom: 1rem;\n" ~ "}\n" ~ "\n"
    ~ "h1 { font-size: 2.2rem; }\n" ~ "h2 { font-size: 1.8rem; }\n"
    ~ "h3 { font-size: 1.4rem; }\n" ~ "\n" ~ "p {\n" ~ "  margin-bottom: 1.5rem;\n"
    ~ "}\n" ~ "\n" ~ "/* Content spacing */\n" ~ ".content-wrapper {\n"
    ~ "  margin-bottom: 2rem;\n" ~ "}\n";

// Functions to generate static content and templates
void generateSampleContent(string path)
{
    std.file.write(buildPath(path, "site", "content", "posts",
            "hello-world.md"), HELLO_WORLD_CONTENT);
    std.file.write(buildPath(path, "site", "content", "pages", "about.md"), ABOUT_PAGE_CONTENT);
}

void generateTemplates(string path)
{
    std.file.write(buildPath(path, "site", "templates", "base.html"), BASE_TEMPLATE);
    std.file.write(buildPath(path, "site", "templates", "index.html"), INDEX_TEMPLATE);
    std.file.write(buildPath(path, "site", "templates", "post.html"), POST_TEMPLATE);
    std.file.write(buildPath(path, "site", "templates", "page.html"), PAGE_TEMPLATE);
}

void generateDefaultStylesheet(string path)
{
    string staticDir = buildPath(path, "site", "static");
    mkdirRecurse(staticDir);
    string cssPath = buildPath(staticDir, "style.css");
    std.file.write(cssPath, DEFAULT_CSS);
}

void generateDefaultStaticFiles(string path)
{
    // Create default robots.txt that disallows all crawlers
    immutable string DEFAULT_ROBOTS_TXT = "User-agent: *\n" ~ "Disallow: /\n";
    std.file.write(buildPath(path, "site", "static", "robots.txt"), DEFAULT_ROBOTS_TXT);
}
