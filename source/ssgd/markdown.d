module ssgd.markdown;

import commonmarkd;
import ssgd.content;

class MarkdownProcessor
{
    void process(Content content)
    {
        if (content.content.length > 0)
        {
            // Process with commonmark-d
            content.htmlContent = convertMarkdownToHTML(content.content);
        }
        else
        {
            content.htmlContent = "";
        }
    }

    void processCollection(ContentCollection collection)
    {
        foreach (content; collection.items)
        {
            process(content);
        }
    }

}
