module tests.content_test;

import std.stdio;
import std.file;
import std.path;
import std.datetime.date;
import std.datetime.systime;
import std.conv;
import std.string;
import ssgd.content;

// Helper function to create a temporary test directory
private string createTestDir(string prefix)
{
    string testDir = buildPath(tempDir(), prefix ~ to!string(Clock.currTime().toUnixTime()));
    mkdirRecurse(testDir);
    return testDir;
}

// Helper function to clean up test directory
private void cleanupTestDir(string testDir)
{
    if (exists(testDir))
    {
        rmdirRecurse(testDir);
    }
}

// Test basic content parsing functionality
unittest
{
    string testDir = createTestDir("ssgd_basic_test_");
    scope (exit)
        cleanupTestDir(testDir);

    string testFile = buildPath(testDir, "test.md");
    string testContent = "Title: Test Post\n" ~ "Author: Test Author\n" ~ "Date: 2025-01-15\n"
        ~ "Slug: test-post\n" ~ "\n" ~ "# Test Content\n" ~ "\n" ~ "This is test content.";
    std.file.write(testFile, testContent);

    auto content = new Content(testFile, "post");
    assert(content.title == "Test Post", "Title parsing failed");
    assert(content.author == "Test Author", "Author parsing failed");
    assert(content.slug == "test-post", "Slug parsing failed");
    assert(content.date == Date(2025, 1, 15), "Date parsing failed");
    assert(content.content == "# Test Content\n\nThis is test content.",
        "Content extraction failed");
    assert(content.url == "/posts/test-post.html", "URL generation failed");
    writeln("[DEBUG_LOG] Basic content parsing test: PASSED");
}

// Test content parsing with missing metadata
unittest
{
    string testDir = createTestDir("ssgd_minimal_test_");
    scope (exit)
        cleanupTestDir(testDir);

    string testFile = buildPath(testDir, "minimal.md");
    string testContent = "Title: Minimal Post\n" ~ "\n" ~ "Just content here.";
    std.file.write(testFile, testContent);

    auto content = new Content(testFile, "post");
    assert(content.title == "Minimal Post", "Title parsing failed");
    assert(content.author == "", "Author should be empty");
    assert(content.slug == "minimal", "Default slug should be filename");
    assert(content.content == "Just content here.", "Content extraction failed");
    writeln("[DEBUG_LOG] Missing metadata test: PASSED");
}

// Test invalid date parsing
unittest
{
    string testDir = createTestDir("ssgd_date_test_");
    scope (exit)
        cleanupTestDir(testDir);

    string testFile = buildPath(testDir, "invalid_date.md");
    string testContent = "Title: Invalid Date Post\n" ~ "Date: invalid-date\n"
        ~ "\n" ~ "Content with invalid date.";
    std.file.write(testFile, testContent);

    auto content = new Content(testFile, "post");
    auto now = Clock.currTime();
    Date currentDate = Date(now.year, now.month, now.day);
    assert(content.date == currentDate, "Should use current date for invalid date");
    writeln("[DEBUG_LOG] Invalid date parsing test: PASSED");
}

// Test page content type
unittest
{
    string testDir = createTestDir("ssgd_page_test_");
    scope (exit)
        cleanupTestDir(testDir);

    string testFile = buildPath(testDir, "page.md");
    string testContent = "Title: Test Page\n" ~ "Slug: test-page\n" ~ "\n" ~ "Page content.";
    std.file.write(testFile, testContent);

    auto content = new Content(testFile, "page");
    assert(content.contentType == "page", "Content type should be page");
    assert(content.url == "/test-page.html", "Page URL should not have posts/ prefix");
    writeln("[DEBUG_LOG] Page content type test: PASSED");
}

// Test file not found exception
unittest
{
    string testDir = createTestDir("ssgd_notfound_test_");
    scope (exit)
        cleanupTestDir(testDir);

    string nonExistentFile = buildPath(testDir, "nonexistent.md");
    try
    {
        auto content = new Content(nonExistentFile, "post");
        assert(false, "Should throw exception for non-existent file");
    }
    catch (Exception e)
    {
        assert(e.msg.indexOf("File not found") >= 0, "Should throw file not found exception");
        writeln("[DEBUG_LOG] File not found test: PASSED");
    }
}

// Test content collection functionality
unittest
{
    string testDir = createTestDir("ssgd_collection_test_");
    scope (exit)
        cleanupTestDir(testDir);

    auto collection = new ContentCollection();

    string post1File = buildPath(testDir, "post1.md");
    std.file.write(post1File, "Title: Post 1\nSlug: post-1\n\nPost 1 content");
    string post2File = buildPath(testDir, "post2.md");
    std.file.write(post2File, "Title: Post 2\nSlug: post-2\n\nPost 2 content");
    string pageFile = buildPath(testDir, "page1.md");
    std.file.write(pageFile, "Title: Page 1\nSlug: page-1\n\nPage 1 content");

    auto post1 = new Content(post1File, "post");
    auto post2 = new Content(post2File, "post");
    auto page1 = new Content(pageFile, "page");

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

    writeln("[DEBUG_LOG] Content collection test: PASSED");
}
