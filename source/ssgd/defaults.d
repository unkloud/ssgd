module ssgd.defaults;

import std.file;
import std.path;

// Sample content constants
immutable string HELLO_WORLD_CONTENT = 
    "Title: Hello World\n" ~
    "Date: 2025-01-01\n" ~
    "Slug: hello-world\n" ~
    "Author: SSGD User\n\n" ~
    "# Hello World\n\n" ~
    "This is a sample post created with SSGD, a static site generator written in D.\n\n" ~
    "## Features\n\n" ~
    "- Markdown support\n" ~
    "- Simple theming\n" ~
    "- Command-line interface similar to Pelican\n" ~
    "- Static linking for easy distribution\n";

immutable string ABOUT_PAGE_CONTENT = 
    "Title: About\n" ~
    "Date: 2025-01-01\n" ~
    "Slug: about\n" ~
    "Author: SSGD User\n\n" ~
    "# About SSGD\n\n" ~
    "SSGD is a static site generator written in the D programming language.\n\n" ~
    "This is a sample page created with SSGD.\n";

// Template constants
immutable string BASE_TEMPLATE = 
    "<!DOCTYPE html>\n" ~
    "<html lang=\"en\">\n" ~
    "<head>\n" ~
    "  <meta charset=\"utf-8\">\n" ~
    "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
    "  <title>{{title}}</title>\n" ~
    "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
    "</head>\n" ~
    "<body>\n" ~
    "  <div class=\"container\">\n" ~
    "    <header class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <nav class=\"nav\">\n" ~
    "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
    "          <div class=\"nav-right\">\n" ~
    "            <a href=\"/\">Home</a>\n" ~
    "            <a href=\"/about.html\">About</a>\n" ~
    "          </div>\n" ~
    "        </nav>\n" ~
    "      </div>\n" ~
    "    </header>\n" ~
    "    <main class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        {{content}}\n" ~
    "      </div>\n" ~
    "    </main>\n" ~
    "    <footer class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
    "      </div>\n" ~
    "    </footer>\n" ~
    "  </div>\n" ~
    "</body>\n" ~
    "</html>\n";

immutable string INDEX_TEMPLATE = 
    "<!DOCTYPE html>\n" ~
    "<html lang=\"en\">\n" ~
    "<head>\n" ~
    "  <meta charset=\"utf-8\">\n" ~
    "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
    "  <title>{{siteName}}</title>\n" ~
    "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
    "</head>\n" ~
    "<body>\n" ~
    "  <div class=\"container\">\n" ~
    "    <header class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <nav class=\"nav\">\n" ~
    "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
    "          <div class=\"nav-right\">\n" ~
    "            <a href=\"/\">Home</a>\n" ~
    "            <a href=\"/about.html\">About</a>\n" ~
    "          </div>\n" ~
    "        </nav>\n" ~
    "      </div>\n" ~
    "    </header>\n" ~
    "    <main class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <h2>Recent Posts</h2>\n" ~
    "        <div class=\"posts\">\n" ~
    "          {{posts}}\n" ~
    "        </div>\n" ~
    "      </div>\n" ~
    "    </main>\n" ~
    "    <footer class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
    "      </div>\n" ~
    "    </footer>\n" ~
    "  </div>\n" ~
    "</body>\n" ~
    "</html>\n";

immutable string POST_TEMPLATE = 
    "<!DOCTYPE html>\n" ~
    "<html lang=\"en\">\n" ~
    "<head>\n" ~
    "  <meta charset=\"utf-8\">\n" ~
    "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
    "  <title>{{title}} - {{siteName}}</title>\n" ~
    "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
    "</head>\n" ~
    "<body>\n" ~
    "  <div class=\"container\">\n" ~
    "    <header class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <nav class=\"nav\">\n" ~
    "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
    "          <div class=\"nav-right\">\n" ~
    "            <a href=\"/\">Home</a>\n" ~
    "            <a href=\"/about.html\">About</a>\n" ~
    "          </div>\n" ~
    "        </nav>\n" ~
    "      </div>\n" ~
    "    </header>\n" ~
    "    <main class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <article class=\"card\">\n" ~
    "          <header>\n" ~
    "            <h2>{{title}}</h2>\n" ~
    "            <p class=\"text-grey\"><small>Posted on {{date}} by {{author}}</small></p>\n" ~
    "          </header>\n" ~
    "          <div class=\"content\">\n" ~
    "            {{content}}\n" ~
    "          </div>\n" ~
    "        </article>\n" ~
    "      </div>\n" ~
    "    </main>\n" ~
    "    <footer class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
    "      </div>\n" ~
    "    </footer>\n" ~
    "  </div>\n" ~
    "</body>\n" ~
    "</html>\n";

immutable string PAGE_TEMPLATE = 
    "<!DOCTYPE html>\n" ~
    "<html lang=\"en\">\n" ~
    "<head>\n" ~
    "  <meta charset=\"utf-8\">\n" ~
    "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n" ~
    "  <title>{{title}} - {{siteName}}</title>\n" ~
    "  <link rel=\"stylesheet\" href=\"https://unpkg.com/chota@latest\">\n" ~
    "</head>\n" ~
    "<body>\n" ~
    "  <div class=\"container\">\n" ~
    "    <header class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <nav class=\"nav\">\n" ~
    "          <a href=\"/\" class=\"brand\">{{siteName}}</a>\n" ~
    "          <div class=\"nav-right\">\n" ~
    "            <a href=\"/\">Home</a>\n" ~
    "            <a href=\"/about.html\">About</a>\n" ~
    "          </div>\n" ~
    "        </nav>\n" ~
    "      </div>\n" ~
    "    </header>\n" ~
    "    <main class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <article class=\"card page\">\n" ~
    "          <header>\n" ~
    "            <h2>{{title}}</h2>\n" ~
    "          </header>\n" ~
    "          <div class=\"content\">\n" ~
    "            {{content}}\n" ~
    "          </div>\n" ~
    "        </article>\n" ~
    "      </div>\n" ~
    "    </main>\n" ~
    "    <footer class=\"row\">\n" ~
    "      <div class=\"col\">\n" ~
    "        <p class=\"text-grey\">&copy; {{copyright}}</p>\n" ~
    "      </div>\n" ~
    "    </footer>\n" ~
    "  </div>\n" ~
    "</body>\n" ~
    "</html>\n";

// Functions to generate static content and templates
void generateSampleContent(string path)
{
    std.file.write(buildPath(path, "site", "content", "posts", "hello-world.md"), HELLO_WORLD_CONTENT);
    std.file.write(buildPath(path, "site", "content", "pages", "about.md"), ABOUT_PAGE_CONTENT);
}

void generateTemplates(string path)
{
    std.file.write(buildPath(path, "site", "templates", "base.html"), BASE_TEMPLATE);
    std.file.write(buildPath(path, "site", "templates", "index.html"), INDEX_TEMPLATE);
    std.file.write(buildPath(path, "site", "templates", "post.html"), POST_TEMPLATE);
    std.file.write(buildPath(path, "site", "templates", "page.html"), PAGE_TEMPLATE);
}
