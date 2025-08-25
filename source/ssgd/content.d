module ssgd.content;

import std.datetime.date;
import std.datetime.systime;
import std.path;
import std.file;
import std.string;
import std.algorithm;
import std.array;
import std.conv;

class Content
{
    string title;
    string author;
    string slug;
    Date date;
    string content;
    string htmlContent;
    string filePath;
    string url;
    string contentType;

    this(string filePath, string contentType = "post")
    {
        this.filePath = filePath;
        this.contentType = contentType;
        this.slug = baseName(filePath, ".md");
        this.url = "/" ~ (contentType == "post" ? "posts/" : "") ~ slug ~ ".html";
        parseFile();
    }

    private void parseFile()
    {
        if (!exists(filePath))
        {
            throw new Exception("File not found: " ~ filePath);
        }
        string fileContent = readText(filePath);
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
        url = "/" ~ (contentType == "post" ? "posts/" : "") ~ slug ~ ".html";
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
            content = lines[startIndex .. $].join("\n");
        }
    }

    string getExcerpt()
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
}

class ContentCollection
{
    Content[] items;

    void add(Content item)
    {
        items ~= item;
    }

    Content[] getByType(string contentType)
    {
        return items.filter!(i => i.contentType == contentType).array;
    }

    Content[] getPosts()
    {
        return getByType("post");
    }

    Content[] getPages()
    {
        return getByType("page");
    }

    Content getBySlug(string slug)
    {
        auto results = items.filter!(i => i.slug == slug).array;
        return results.length > 0 ? results[0] : null;
    }
}
