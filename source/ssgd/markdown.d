module ssgd.markdown;

import commonmarkd;
import ssgd.content;

struct RenderedContent
{
    Content content;
    string renderedOutput;
}

class MarkdownProcessor
{
    string process(Content content)
    {
        string rendered = "";
        if (content.pageContent.length > 0)
        {
            rendered = convertMarkdownToHTML(content.pageContent);
        }
        return rendered;
    }

    void processCollection(ContentCollection collection)
    {
        foreach (content; collection.items)
        {
            process(content);
        }
    }
}
