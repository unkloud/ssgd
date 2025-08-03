import std.stdio;
import std.string;
import std.array;

string getExcerpt(string content)
{
    if (content.empty)
        return "";
    
    auto paragraphs = content.split("\n\n");
    string excerpt = "";
    int paragraphCount = 0;
    
    foreach (paragraph; paragraphs)
    {
        auto trimmed = paragraph.strip();
        if (!trimmed.empty && !trimmed.startsWith("#"))
        {
            if (paragraphCount > 0)
                excerpt ~= "\n\n";
            excerpt ~= trimmed;
            paragraphCount++;
            if (paragraphCount >= 2)
                break;
        }
    }
    
    return excerpt;
}

void main()
{
    string testContent = "# Hello World\n\nThis is a sample post created with SSGD, a static site generator written in D.\n\n## Features\n\n- Markdown support\n- Simple theming\n- Command-line interface similar to Pelican\n- Static linking for easy distribution";
    
    string excerpt = getExcerpt(testContent);
    writeln("Excerpt:");
    writeln(excerpt);
}
