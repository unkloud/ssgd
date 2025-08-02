module ssgd.styles;

import std.file;
import std.path;

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

// Default CSS file content
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

// Function to generate default stylesheet
void generateDefaultStylesheet(string path)
{
    string staticDir = buildPath(path, "site", "static");
    mkdirRecurse(staticDir);
    string cssPath = buildPath(staticDir, "style.css");
    std.file.write(cssPath, DEFAULT_CSS);
}
