module tests.content_test;

import std.stdio;
import std.datetime.date;
import std.datetime.systime;
import std.string;
import ssgd.content;

// Test basic content parsing functionality
unittest
{
    string testContent = "Title: Test Post\n" ~ "Author: Test Author\n" ~ "Date: 2025-01-15\n"
        ~ "Slug: test-post\n" ~ "\n" ~ "# Test Content\n" ~ "\n" ~ "This is test content.";
    auto provider = new StringContentProvider(testContent, "post", "test-post");
    auto content = new PresentableContent(provider);
    assert(content.title == "Test Post", "Title parsing failed");
    assert(content.author == "Test Author", "Author parsing failed");
    assert(content.slug == "test-post", "Slug parsing failed");
    assert(content.date == Date(2025, 1, 15), "Date parsing failed");
    assert(content.pageContent == "# Test Content\n\nThis is test content.",
            "Content extraction failed");
    assert(content.relativeUrl() == "/posts/test-post.html", "URL generation failed");
}

// Test content parsing with missing metadata
unittest
{
    string testContent = "Title: Minimal Post\nSlug: minimal\n" ~ "\n" ~ "Just content here.";
    auto provider = new StringContentProvider(testContent, "post", "minimal");
    auto content = new PresentableContent(provider);
    assert(content.title == "Minimal Post", "Title parsing failed");
    assert(content.author == "", "Author should be empty");
    assert(content.slug == "minimal", "Default slug should be filename");
    assert(content.pageContent == "Just content here.", "Content extraction failed");
}

// Test invalid date parsing
unittest
{
    string testContent = "Title: Invalid Date Post\n" ~ "Date: invalid-date\n"
        ~ "Slug: invalid_date\n" ~ "\n" ~ "Content with invalid date.";
    auto provider = new StringContentProvider(testContent, "post", "invalid_date");
    auto content = new PresentableContent(provider);
    auto now = Clock.currTime();
    Date currentDate = Date(now.year, now.month, now.day);
    assert(content.date == currentDate, "Should use current date for invalid date");
}

// Test page content type
unittest
{
    string testContent = "Title: Test Page\n" ~ "Slug: test-page\n" ~ "\n" ~ "Page content.";
    auto provider = new StringContentProvider(testContent, "page", "test-page");
    auto content = new PresentableContent(provider);
    assert(content.contentProvider.getSiteContentType() == "page", "Content type should be page");
    assert(content.relativeUrl() == "/test-page.html", "Page URL should not have posts/ prefix");
}

// Test file not found exception
unittest
{
    string nonExistentFile = "/tmp/nonexistent.md";
    auto provider = new FileContentProvider(nonExistentFile, "post");
    try
    {
        auto content = new PresentableContent(provider);
        assert(false, "Should throw exception for non-existent file");
    }
    catch (Exception e)
    {
        assert(e.msg.indexOf("File not found") >= 0, "Should throw file not found exception");
    }
}

// Test content collection functionality
unittest
{
    auto collection = new PresentableContentCollection();

    auto provider1 = new StringContentProvider(
            "Title: Post 1\nSlug: post-1\n\nPost 1 content", "post", "post-1");
    auto provider2 = new StringContentProvider(
            "Title: Post 2\nSlug: post-2\n\nPost 2 content", "post", "post-2");
    auto provider3 = new StringContentProvider(
            "Title: Page 1\nSlug: page-1\n\nPage 1 content", "page", "page-1");
    auto post1 = new PresentableContent(provider1);
    auto post2 = new PresentableContent(provider2);
    auto page1 = new PresentableContent(provider3);
    collection.add(post1);
    collection.add(post2);
    collection.add(page1);
    auto posts = collection.getPosts();
    assert(posts.length == 2, "Should have 2 posts");
    auto pages = collection.getPages();
    assert(pages.length == 1, "Should have 1 page");
    auto foundPost = collection.getBySlug("post-1");
    assert(foundPost !is null, "Should find post by slug");
    assert(foundPost.title == "Post 1", "Should return correct post");
    auto notFound = collection.getBySlug("nonexistent");
    assert(notFound is null, "Should return null for non-existent slug");
}
