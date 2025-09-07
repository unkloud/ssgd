module ssgd.content;

import std.datetime.date;
import std.datetime.systime;
import std.path;
import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.conv;

interface ContentProvider
{
    string getRawContent();
    string getSiteContentType();
}

class FileContentProvider : ContentProvider
{
    private string filePath;
    private string contentType;

    this(string filePath, string contentType)
    {
        this.filePath = filePath;
        this.contentType = contentType;
    }

    string getRawContent()
    {
        if (!exists(filePath))
        {
            throw new Exception("File not found: " ~ filePath);
        }
        return readText(filePath);
    }

    string getSiteContentType()
    {
        return contentType;
    }

    string getFilePath()
    {
        return filePath;
    }
}

class StringContentProvider : ContentProvider
{
    private string content;
    private string contentType;
    private string slug;

    this(string content, string contentType, string slug)
    {
        this.content = content;
        this.contentType = contentType;
        this.slug = slug;
    }

    string getRawContent()
    {
        return content;
    }

    string getSiteContentType()
    {
        return contentType;
    }

    string asSlug()
    {
        return slug;
    }
}

class PresentableContent
{
    string title;
    string author;
    Date date;
    string slug;
    string pageContent;
    ContentProvider contentProvider;
    string renderedHtml;

    this(ContentProvider provider)
    {
        this.contentProvider = provider;
        parseContent(provider);
        assert((slug !is null), "The slug should not be null");
    }

    private void parseContent(ContentProvider provider)
    {
        string fileContent = provider.getRawContent();
        auto lines = fileContent.splitLines();
        size_t contentStart = parseMetadata(lines);
        extractContent(lines, contentStart);
    }

    private size_t parseMetadata(string[] lines)
    {
        for (size_t i = 0; i < lines.length; i++)
        {
            auto line = lines[i].strip();
            if (line.empty)
            {
                return i + 1;
            }
            parseMetadataLine(line);
        }
        return lines.length;
    }

    private void parseMetadataLine(string line)
    {
        auto parts = line.findSplit(":");
        if (parts[1].empty)
            return;
        auto key = parts[0].strip().toLower();
        auto value = parts[2].strip();
        switch (key)
        {
        case "title":
            title = value;
            break;
        case "author":
            author = value;
            break;
        case "slug":
            setSlug(value);
            break;
        case "date":
            parseDate(value);
            break;
        default:
            break;
        }
    }

    private void setSlug(string newSlug)
    {
        slug = newSlug;
    }

    private void parseDate(string dateString)
    {
        try
        {
            auto dateParts = dateString.split("-").map!(to!int).array;
            if (dateParts.length >= 3)
            {
                date = Date(dateParts[0], dateParts[1], dateParts[2]);
                return;
            }
        }
        catch (Exception e)
        {
        }
        import std.datetime.systime : Clock;

        SysTime currentTime = Clock.currTime();
        date = Date(currentTime.year, currentTime.month, currentTime.day);
    }

    private void extractContent(string[] lines, size_t startIndex)
    {
        if (startIndex < lines.length)
        {
            pageContent = lines[startIndex .. $].join("\n");
        }
    }

    string relativeUrl()
    {
        return "/" ~ (contentProvider.getSiteContentType() == "post" ? "posts/" : "")
            ~ slug ~ ".html";
    }

    string getExcerpt()
    {
        if (pageContent.empty)
        {
            return "";
        }
        auto paragraphs = pageContent.split("\n\n");
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
}

class PresentableContentCollection
{
    PresentableContent[] items;

    void add(PresentableContent item)
    {
        items ~= item;
    }

    PresentableContent[] getByType(string contentType)
    {
        return items.filter!(i => i.contentProvider.getSiteContentType() == contentType).array;
    }

    PresentableContent[] getPosts()
    {
        return getByType("post");
    }

    PresentableContent[] getPages()
    {
        return getByType("page");
    }

    PresentableContent getBySlug(string slug)
    {
        auto results = items.filter!(i => i.slug == slug).array;
        return results.length > 0 ? results[0] : null;
    }
}
