module tests.pagination_test;

import std.stdio;
import std.file;
import std.path;
import std.string;
import std.conv;
import std.datetime.date;
import std.datetime.systime;
import std.algorithm;
import std.array;
import ssgd.content;
import ssgd.renderer;

// Helper function to create test posts
Content[] createTestPosts(int count)
{
    Content[] posts;
    for (int i = 1; i <= count; i++)
    {
        string testContent = "Title: Test Post " ~ to!string(
                i) ~ "\n" ~ "Author: Test Author " ~ to!string(
                i) ~ "\n" ~ "Date: 2025-01-" ~ (i <= 31 ? (i < 10
                ? "0" : "") ~ to!string(i) : "31") ~ "\n" ~ "Slug: test-post-" ~ to!string(
                i) ~ "\n\n" ~ "This is test content for post " ~ to!string(
                i) ~ ".\n\n" ~ "Second paragraph of post " ~ to!string(i) ~ ".";
        auto provider = new StringContentProvider(testContent, "post",
                "test-post-" ~ to!string(i));
        auto post = new Content(provider);
        posts ~= post;
    }
    return posts;
}

// Helper function to create temporary test directory
string createTestDir(string prefix)
{
    string testDir = buildPath(tempDir(), prefix ~ to!string(Clock.currTime().toUnixTime()));
    mkdirRecurse(testDir);
    return testDir;
}

// Helper function to clean up test directory
void cleanupTestDir(string testDir)
{
    if (exists(testDir))
    {
        rmdirRecurse(testDir);
    }
}

// Helper function to set up template files
void setupTemplates(string testDir)
{
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string indexTemplate = "{{posts}}{{pagination}}";
    string postItemTemplate = "<div class=\"post-item\">\n<h2>{{title}}</h2>\n<p>{{content}}</p>\n</div>";
    string baseTemplate = "{{content}}";
    string paginationTemplate = "<nav>{{prevLink}}{{pageLinks}}{{nextLink}}</nav>";
    std.file.write(buildPath(templateDir, "index.html"), indexTemplate);
    std.file.write(buildPath(templateDir, "post_item.html"), postItemTemplate);
    std.file.write(buildPath(templateDir, "base.html"), baseTemplate);
    std.file.write(buildPath(templateDir, "pagination.html"), paginationTemplate);
}

// Test pagination calculation with different post counts
unittest
{

    // Test with 0 posts
    auto collection = new ContentCollection();
    auto posts = createTestPosts(0);
    foreach (post; posts)
        collection.add(post);

    string testDir = createTestDir("ssgd_pagination_zero_");
    scope (exit)
        cleanupTestDir(testDir);

    setupTemplates(testDir);

    auto renderer = new HtmlRenderer(testDir, testDir, "Test Site", "/",
            "Test Copyright", Pagination(5));
    auto processor = new MarkdownProcessor();
    auto renderedCollection = processor.processCollection(collection);
    renderer.renderIndex(renderedCollection);

    assert(exists(buildPath(testDir, "index.html")), "Index file should exist even with 0 posts");
}

// Test pagination with posts fitting exactly in one page
unittest
{

    auto collection = new ContentCollection();
    auto posts = createTestPosts(5); // Exactly 5 posts for pagination=5
    foreach (post; posts)
        collection.add(post);

    string testDir = createTestDir("ssgd_pagination_single_");
    scope (exit)
        cleanupTestDir(testDir);

    setupTemplates(testDir);

    auto renderer = new HtmlRenderer(testDir, testDir, "Test Site", "/",
            "Test Copyright", Pagination(5));
    auto processor = new MarkdownProcessor();
    auto renderedCollection = processor.processCollection(collection);
    renderer.renderIndex(renderedCollection);

    assert(exists(buildPath(testDir, "index.html")), "Index file should exist");
    assert(!exists(buildPath(testDir, "page2.html")), "Page 2 should not exist with only 5 posts");
}

// Test pagination with multiple pages
unittest
{

    auto collection = new ContentCollection();
    auto posts = createTestPosts(12); // 12 posts with pagination=5 should create 3 pages
    foreach (post; posts)
        collection.add(post);

    string testDir = createTestDir("ssgd_pagination_multi_");
    scope (exit)
        cleanupTestDir(testDir);

    setupTemplates(testDir);

    auto renderer = new HtmlRenderer(testDir, testDir, "Test Site", "/",
            "Test Copyright", Pagination(5));
    auto processor = new MarkdownProcessor();
    auto renderedCollection = processor.processCollection(collection);
    renderer.renderIndex(renderedCollection);

    assert(exists(buildPath(testDir, "index.html")), "Index file should exist");
    assert(exists(buildPath(testDir, "page2.html")), "Page 2 should exist");
    assert(exists(buildPath(testDir, "page3.html")), "Page 3 should exist");
    assert(!exists(buildPath(testDir, "page4.html")), "Page 4 should not exist");
}

// Test pagination HTML generation
unittest
{

    auto collection = new ContentCollection();
    auto posts = createTestPosts(8); // 8 posts with pagination=3 should create 3 pages
    foreach (post; posts)
        collection.add(post);

    string testDir = createTestDir("ssgd_pagination_html_");
    scope (exit)
        cleanupTestDir(testDir);

    setupTemplates(testDir);
    // Override index template for this specific test
    string templateContent = "POSTS:{{posts}}PAGINATION:{{pagination}}";
    std.file.write(buildPath(testDir, "templates", "index.html"), templateContent);

    auto renderer = new HtmlRenderer(testDir, testDir, "Test Site", "/",
            "Test Copyright", Pagination(3));
    auto processor = new MarkdownProcessor();
    auto renderedCollection = processor.processCollection(collection);
    renderer.renderIndex(renderedCollection);

    // Check page 1 (index.html) - posts are sorted newest first
    string page1Content = readText(buildPath(testDir, "index.html"));
    assert(page1Content.canFind("Test Post 8"), "Page 1 should contain eighth post (newest)");
    assert(page1Content.canFind("Test Post 6"), "Page 1 should contain sixth post");
    assert(!page1Content.canFind("Test Post 5"), "Page 1 should not contain fifth post");
    assert(page1Content.canFind("Next"), "Page 1 should have Next link");
    assert(!page1Content.canFind("Previous"), "Page 1 should not have Previous link");

    // Check page 2 - middle posts in reverse chronological order
    string page2Content = readText(buildPath(testDir, "page2.html"));
    assert(page2Content.canFind("Test Post 5"), "Page 2 should contain fifth post");
    assert(page2Content.canFind("Test Post 3"), "Page 2 should contain third post");
    assert(!page2Content.canFind("Test Post 6"), "Page 2 should not contain sixth post");
    assert(!page2Content.canFind("Test Post 2"), "Page 2 should not contain second post");
    assert(page2Content.canFind("Previous"), "Page 2 should have Previous link");
    assert(page2Content.canFind("Next"), "Page 2 should have Next link");

    // Check page 3 - oldest posts
    string page3Content = readText(buildPath(testDir, "page3.html"));
    assert(page3Content.canFind("Test Post 2"), "Page 3 should contain second post");
    assert(page3Content.canFind("Test Post 1"), "Page 3 should contain first post (oldest)");
    assert(!page3Content.canFind("Test Post 3"), "Page 3 should not contain third post");
    assert(page3Content.canFind("Previous"), "Page 3 should have Previous link");
    assert(!page3Content.canFind("Next"), "Page 3 should not have Next link");

}

// Test pagination URL generation
unittest
{

    auto collection = new ContentCollection();
    auto posts = createTestPosts(7); // 7 posts with pagination=3 should create 3 pages
    foreach (post; posts)
        collection.add(post);

    string testDir = createTestDir("ssgd_pagination_urls_");
    scope (exit)
        cleanupTestDir(testDir);

    setupTemplates(testDir);
    // Override index template for this specific test
    string templateContent = "{{pagination}}";
    std.file.write(buildPath(testDir, "templates", "index.html"), templateContent);

    auto renderer = new HtmlRenderer(testDir, testDir, "Test Site", "/",
            "Test Copyright", Pagination(3));
    auto processor = new MarkdownProcessor();
    auto renderedCollection = processor.processCollection(collection);
    renderer.renderIndex(renderedCollection);

    // Check page 2 for correct URL generation
    string page2Content = readText(buildPath(testDir, "page2.html"));
    assert(page2Content.canFind("href=\"index.html\""),
            "Page 2 should link to index.html for page 1");
    assert(page2Content.canFind("href=\"page3.html\""),
            "Page 2 should link to page3.html for page 3");
    assert(page2Content.canFind("class=\"button primary\""),
            "Page 2 should have primary class on current page");

}

// Test post sorting by date
unittest
{

    auto collection = new ContentCollection();

    // Create posts with different dates (not in chronological order)
    auto provider1 = new StringContentProvider(
            "Title: Oldest Post\nDate: 2025-01-01\nSlug: oldest\n\nOldest content.",
            "post", "oldest");
    auto post1 = new Content(provider1);

    auto provider2 = new StringContentProvider(
            "Title: Newest Post\nDate: 2025-01-15\nSlug: newest\n\nNewest content.",
            "post", "newest");
    auto post2 = new Content(provider2);

    auto provider3 = new StringContentProvider(
            "Title: Middle Post\nDate: 2025-01-10\nSlug: middle\n\nMiddle content.",
            "post", "middle");
    auto post3 = new Content(provider3);

    collection.add(post1);
    collection.add(post2);
    collection.add(post3);

    string testDir = createTestDir("ssgd_pagination_sort_");
    scope (exit)
        cleanupTestDir(testDir);

    setupTemplates(testDir);
    // Override index template for this specific test
    string templateContent = "{{posts}}";
    std.file.write(buildPath(testDir, "templates", "index.html"), templateContent);

    auto renderer = new HtmlRenderer(testDir, testDir, "Test Site", "/",
            "Test Copyright", Pagination(10));
    auto processor = new MarkdownProcessor();
    auto renderedCollection = processor.processCollection(collection);
    renderer.renderIndex(renderedCollection);

    string indexContent = readText(buildPath(testDir, "index.html"));

    // Check that newest post appears first
    auto newestPos = indexContent.indexOf("Newest Post");
    auto middlePos = indexContent.indexOf("Middle Post");
    auto oldestPos = indexContent.indexOf("Oldest Post");

    assert(newestPos < middlePos, "Newest post should appear before middle post");
    assert(middlePos < oldestPos, "Middle post should appear before oldest post");

}
