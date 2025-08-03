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
import ssgd.pagination;

// Helper function to create test posts
Content[] createTestPosts(int count)
{
    Content[] posts;
    for (int i = 1; i <= count; i++)
    {
        auto post = new Content("", "post");
        post.title = "Test Post " ~ to!string(i);
        post.author = "Test Author " ~ to!string(i);
        post.slug = "test-post-" ~ to!string(i);
        post.date = Date(2025, 1, i <= 31 ? i : 31);
        post.content = "This is test content for post " ~ to!string(i) ~ ".\n\nSecond paragraph of post " ~ to!string(i) ~ ".";
        post.url = "/posts/test-post-" ~ to!string(i) ~ ".html";
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

// Test pagination calculation with different post counts
unittest
{
    writeln("[DEBUG_LOG] Testing pagination calculation...");
    
    // Test with 0 posts
    auto collection = new ContentCollection();
    auto posts = createTestPosts(0);
    foreach (post; posts) collection.add(post);
    
    string testDir = createTestDir("ssgd_pagination_zero_");
    scope(exit) cleanupTestDir(testDir);
    
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string templateContent = "{{posts}}{{pagination}}";
    std.file.write(buildPath(templateDir, "index.html"), templateContent);
    
    auto renderer = new Renderer(testDir, testDir, "Test Site", "/", "Test Copyright", Pagination(5));
    renderer.renderIndex(collection);
    
    assert(exists(buildPath(testDir, "index.html")), "Index file should exist even with 0 posts");
    writeln("[DEBUG_LOG] Zero posts pagination test: PASSED");
}

// Test pagination with posts fitting exactly in one page
unittest
{
    writeln("[DEBUG_LOG] Testing single page pagination...");
    
    auto collection = new ContentCollection();
    auto posts = createTestPosts(5); // Exactly 5 posts for pagination=5
    foreach (post; posts) collection.add(post);
    
    string testDir = createTestDir("ssgd_pagination_single_");
    scope(exit) cleanupTestDir(testDir);
    
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string templateContent = "{{posts}}{{pagination}}";
    std.file.write(buildPath(templateDir, "index.html"), templateContent);
    
    auto renderer = new Renderer(testDir, testDir, "Test Site", "/", "Test Copyright", Pagination(5));
    renderer.renderIndex(collection);
    
    assert(exists(buildPath(testDir, "index.html")), "Index file should exist");
    assert(!exists(buildPath(testDir, "page2.html")), "Page 2 should not exist with only 5 posts");
    writeln("[DEBUG_LOG] Single page pagination test: PASSED");
}

// Test pagination with multiple pages
unittest
{
    writeln("[DEBUG_LOG] Testing multiple page pagination...");
    
    auto collection = new ContentCollection();
    auto posts = createTestPosts(12); // 12 posts with pagination=5 should create 3 pages
    foreach (post; posts) collection.add(post);
    
    string testDir = createTestDir("ssgd_pagination_multi_");
    scope(exit) cleanupTestDir(testDir);
    
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string templateContent = "{{posts}}{{pagination}}";
    std.file.write(buildPath(templateDir, "index.html"), templateContent);
    
    auto renderer = new Renderer(testDir, testDir, "Test Site", "/", "Test Copyright", Pagination(5));
    renderer.renderIndex(collection);
    
    assert(exists(buildPath(testDir, "index.html")), "Index file should exist");
    assert(exists(buildPath(testDir, "page2.html")), "Page 2 should exist");
    assert(exists(buildPath(testDir, "page3.html")), "Page 3 should exist");
    assert(!exists(buildPath(testDir, "page4.html")), "Page 4 should not exist");
    writeln("[DEBUG_LOG] Multiple page pagination test: PASSED");
}

// Test pagination HTML generation
unittest
{
    writeln("[DEBUG_LOG] Testing pagination HTML generation...");
    
    auto collection = new ContentCollection();
    auto posts = createTestPosts(8); // 8 posts with pagination=3 should create 3 pages
    foreach (post; posts) collection.add(post);
    
    string testDir = createTestDir("ssgd_pagination_html_");
    scope(exit) cleanupTestDir(testDir);
    
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string templateContent = "POSTS:{{posts}}PAGINATION:{{pagination}}";
    std.file.write(buildPath(templateDir, "index.html"), templateContent);
    
    auto renderer = new Renderer(testDir, testDir, "Test Site", "/", "Test Copyright", Pagination(3));
    renderer.renderIndex(collection);
    
    // Check page 1 (index.html)
    string page1Content = readText(buildPath(testDir, "index.html"));
    assert(page1Content.canFind("Test Post 1"), "Page 1 should contain first post");
    assert(page1Content.canFind("Test Post 3"), "Page 1 should contain third post");
    assert(!page1Content.canFind("Test Post 4"), "Page 1 should not contain fourth post");
    assert(page1Content.canFind("Next"), "Page 1 should have Next link");
    assert(!page1Content.canFind("Previous"), "Page 1 should not have Previous link");
    
    // Check page 2
    string page2Content = readText(buildPath(testDir, "page2.html"));
    assert(page2Content.canFind("Test Post 4"), "Page 2 should contain fourth post");
    assert(page2Content.canFind("Test Post 6"), "Page 2 should contain sixth post");
    assert(!page2Content.canFind("Test Post 3"), "Page 2 should not contain third post");
    assert(!page2Content.canFind("Test Post 7"), "Page 2 should not contain seventh post");
    assert(page2Content.canFind("Previous"), "Page 2 should have Previous link");
    assert(page2Content.canFind("Next"), "Page 2 should have Next link");
    
    // Check page 3
    string page3Content = readText(buildPath(testDir, "page3.html"));
    assert(page3Content.canFind("Test Post 7"), "Page 3 should contain seventh post");
    assert(page3Content.canFind("Test Post 8"), "Page 3 should contain eighth post");
    assert(!page3Content.canFind("Test Post 6"), "Page 3 should not contain sixth post");
    assert(page3Content.canFind("Previous"), "Page 3 should have Previous link");
    assert(!page3Content.canFind("Next"), "Page 3 should not have Next link");
    
    writeln("[DEBUG_LOG] Pagination HTML generation test: PASSED");
}

// Test pagination URL generation
unittest
{
    writeln("[DEBUG_LOG] Testing pagination URL generation...");
    
    auto collection = new ContentCollection();
    auto posts = createTestPosts(7); // 7 posts with pagination=3 should create 3 pages
    foreach (post; posts) collection.add(post);
    
    string testDir = createTestDir("ssgd_pagination_urls_");
    scope(exit) cleanupTestDir(testDir);
    
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string templateContent = "{{pagination}}";
    std.file.write(buildPath(templateDir, "index.html"), templateContent);
    
    auto renderer = new Renderer(testDir, testDir, "Test Site", "/", "Test Copyright", Pagination(3));
    renderer.renderIndex(collection);
    
    // Check page 2 for correct URL generation
    string page2Content = readText(buildPath(testDir, "page2.html"));
    assert(page2Content.canFind("href=\"index.html\""), "Page 2 should link to index.html for page 1");
    assert(page2Content.canFind("href=\"page3.html\""), "Page 2 should link to page3.html for page 3");
    assert(page2Content.canFind("class=\"active\""), "Page 2 should have active class on current page");
    
    writeln("[DEBUG_LOG] Pagination URL generation test: PASSED");
}

// Test post sorting by date
unittest
{
    writeln("[DEBUG_LOG] Testing post sorting by date...");
    
    auto collection = new ContentCollection();
    
    // Create posts with different dates (not in chronological order)
    auto post1 = new Content("", "post");
    post1.title = "Oldest Post";
    post1.date = Date(2025, 1, 1);
    post1.content = "Oldest content.";
    post1.url = "/posts/oldest.html";
    
    auto post2 = new Content("", "post");
    post2.title = "Newest Post";
    post2.date = Date(2025, 1, 15);
    post2.content = "Newest content.";
    post2.url = "/posts/newest.html";
    
    auto post3 = new Content("", "post");
    post3.title = "Middle Post";
    post3.date = Date(2025, 1, 10);
    post3.content = "Middle content.";
    post3.url = "/posts/middle.html";
    
    collection.add(post1);
    collection.add(post2);
    collection.add(post3);
    
    string testDir = createTestDir("ssgd_pagination_sort_");
    scope(exit) cleanupTestDir(testDir);
    
    string templateDir = buildPath(testDir, "templates");
    mkdirRecurse(templateDir);
    string templateContent = "{{posts}}";
    std.file.write(buildPath(templateDir, "index.html"), templateContent);
    
    auto renderer = new Renderer(testDir, testDir, "Test Site", "/", "Test Copyright", Pagination(10));
    renderer.renderIndex(collection);
    
    string indexContent = readText(buildPath(testDir, "index.html"));
    
    // Check that newest post appears first
    auto newestPos = indexContent.indexOf("Newest Post");
    auto middlePos = indexContent.indexOf("Middle Post");
    auto oldestPos = indexContent.indexOf("Oldest Post");
    
    assert(newestPos < middlePos, "Newest post should appear before middle post");
    assert(middlePos < oldestPos, "Middle post should appear before oldest post");
    
    writeln("[DEBUG_LOG] Post sorting by date test: PASSED");
}
