# SSGD - Static Site Generator in D

SSGD is a fast and simple static site generator written in the D programming language. It provides a clean command-line interface for creating, building, and serving static websites from Markdown content.

## ⚠️ Important Notice

**Personal Use Project**: This is a vibe-coded project created primarily for the author's personal use and experimentation. While you're welcome to explore and use it, please be aware that:

- The project may undergo unexpected changes or breaking updates without prior notice
- Features may be added, modified, or removed based on personal needs rather than general use cases
- The project could be abandoned or archived at any time without warning
- Limited support and documentation may be available

**Use at your own risk** - Please evaluate whether this project meets your needs and consider the potential for changes before depending on it for critical applications.

## Features

- **Simple CLI Interface**: Easy-to-use commands similar to popular static site generators
- **Markdown Support**: Write content in Markdown with YAML-like metadata headers
- **Template System**: Simple `{{variable}}` placeholder templating
- **Theme Support**: Customizable themes with templates and static assets
- **Fast Build Process**: Efficient static site generation written in D
- **Local Development Server**: Built-in serve command for development
- **Static Linking**: Distributable single binary executable

## Installation

### Prerequisites

- D compiler (DMD, LDC, or GDC)
- DUB (D package manager)

### Building from Source

1. Clone the repository:
```bash
git clone <repository-url>
cd ssgd
```

2. Build the project:
```bash
dub build
```

3. For a release build with static linking:
```bash
dub build --build=release
```

4. The executable will be created in the project directory as `ssgd` (or `ssgd.exe` on Windows).

### Running Tests

```bash
dub test
```

## Usage

### Quick Start

1. **Initialize a new site:**
```bash
./ssgd init my-site
cd my-site
```

2. **Build the site:**
```bash
../ssgd build
```

3. **Serve locally for development:**
```bash
../ssgd serve
```

4. **View your site at http://localhost:8000**

### CLI Commands

#### `ssgd init [path]`
Initialize a new site structure in the specified directory (defaults to current directory).

**Example:**
```bash
ssgd init my-blog
ssgd init  # Initialize in current directory
```

This creates:
- `site/content/posts/` - Directory for blog posts
- `site/content/pages/` - Directory for static pages
- `site/templates/` - HTML templates
- `site/static/` - Static assets (CSS, images, etc.)
- `build/` - Output directory
- Sample content and default theme

#### `ssgd build [options]`
Build the static site from content and templates.

**Options:**
- `--content=PATH` - Path to content directory (default: `site/content`)
- `--output=PATH` - Path to output directory (default: `build`)
- `--theme=PATH` - Theme directory path (default: `site`)
- `--name=NAME` - Site name (default: `SSGD Site`)
- `--url=URL` - Site base URL (default: `/`)

**Examples:**
```bash
ssgd build
ssgd build --name="My Blog" --url="https://myblog.com"
ssgd build --content=content --output=dist --theme=themes/minimal
```

#### `ssgd serve [options]`
Serve the generated site locally for development.

**Options:**
- `--port=PORT` - Port to serve on (default: `8000`)
- `--output=PATH` - Path to output directory (default: `build`)

**Examples:**
```bash
ssgd serve
ssgd serve --port=3000
ssgd serve --output=dist --port=8080
```

#### `ssgd help`
Display help information and usage examples.

#### `ssgd version`
Display version information.

## Project Structure

### Site Directory Layout

```
my-site/
├── site/
│   ├── content/
│   │   ├── posts/          # Blog posts (.md files)
│   │   │   └── hello-world.md
│   │   └── pages/          # Static pages (.md files)
│   │       └── about.md
│   ├── templates/          # HTML templates
│   │   ├── index.html      # Homepage template
│   │   ├── post.html       # Blog post template
│   │   └── page.html       # Static page template
│   └── static/             # Static assets
│       └── style.css
└── build/                  # Generated site output
    ├── index.html
    ├── posts/
    │   └── hello-world.html
    ├── about.html
    └── css/
        └── style.css
```

### Content Format

Content files use Markdown with metadata headers:

```markdown
Title: My Blog Post
Date: 2025-01-15
Slug: my-blog-post
Author: Your Name

# My Blog Post

This is the content of your blog post written in **Markdown**.

## Features

- Markdown formatting
- Metadata support
- Automatic URL generation
```

**Required Metadata:**
- `Title` - Page/post title
- `Date` - Publication date (YYYY-MM-DD format)
- `Slug` - URL slug (auto-generated from title if not provided)
- `Author` - Content author

### Template Variables

Templates use `{{variable}}` syntax for placeholders:

**Global Variables:**
- `{{siteName}}` - Site name
- `{{siteUrl}}` - Site base URL
- `{{copyright}}` - Copyright notice

**Content Variables:**
- `{{title}}` - Content title
- `{{content}}` - Rendered HTML content
- `{{author}}` - Content author
- `{{date}}` - Publication date
- `{{slug}}` - URL slug

**Index Page Variables:**
- `{{posts}}` - List of recent posts (HTML)

## Templates and Stylesheet Resolution
- The default templates link to Chota (https://jenil.github.io/chota/) via unpkg for base styles.
- SSGD now generates an empty stylesheet at `site/static/style.css` during `ssgd init` for optional custom overrides.
- There is no bundled/custom default CSS anymore and no inline styles are injected by SSGD.
- You do NOT need to ship any `templates/default_stylesheet.css` next to the executable; that mechanism was removed.
- Important: Rendering no longer falls back to built-in/default template strings. All required template files must exist, otherwise SSGD will throw an error. Required templates:
  - Theme templates under your theme path (default: `site/templates/`): `base.html`, `index.html`, `post.html`, `page.html`, `post_item.html`, `pagination.html`.
  - All templates are now generated in the same location (`site/templates/`) for consistency. If any template files are missing, rendering will fail with a template-not-found error.

### Customizing Styles
- Add your own CSS rules to `site/static/style.css` if you want to override Chota defaults.
- Keep your overrides minimal to preserve Chota’s small, clean look.
- If you replace the default templates under `site/templates/`, keep the `{{content}}` placeholder in `base.html` and ensure your layout includes the Chota CDN link and `/style.css`.

## Source Code Structure

```
source/
├── app.d                   # Main application entry point
└── ssgd/
    ├── cli.d              # Command-line interface
    ├── generator.d        # Site generation orchestrator
    ├── content.d          # Content parsing and management
    ├── markdown.d         # Markdown processing
    └── renderer.d         # Template rendering and output
tests/
├── test_runner.d          # Test suite runner
├── content_test.d         # Content parsing tests
└── pagination_test.d      # Multiple page support tests
```

### Test Coverage

**Content Tests (`content_test.d`):**
- Basic content parsing and metadata extraction
- Missing metadata handling
- Invalid date parsing with fallback to current date
- Page vs post content type differentiation
- File not found exception handling
- Content collection functionality

**Pagination Tests (`pagination_test.d`):**
- Pagination calculation with different post counts (0, exact fit, multiple pages)
- Single page vs multiple page scenarios
- Post distribution across pages
- Pagination HTML generation with navigation links
- URL generation for page files (index.html, page2.html, etc.)
- Post sorting by date (newest first)

### Key Classes

- **CLI** - Handles command-line interface and argument parsing
- **SiteGenerator** - Orchestrates the site generation process
- **ContentCollection** - Manages content items (posts and pages)
- **Content** - Represents individual content items with metadata
- **MarkdownProcessor** - Converts Markdown to HTML
- **Renderer** - Handles template processing and file output

## Development

### Building

```bash
# Debug build
dub build

# Release build with optimizations
dub build --build=release

# Run tests
dub test
```

### Dependencies

- **commonmarkd** (~>1.0.1) - Markdown processing
- **vibe-d** (~>0.9.7) - HTTP server for local development serving

## TODO - Possible Improvements

### Core Features
- [ ] **Advanced Template Engine** - Replace simple string replacement with Diet-NG templates
- [ ] **Configuration File** - Support for `ssgd.json` or `ssgd.yaml` configuration files
- [ ] **Multiple Theme Support** - Theme switching and custom theme installation
- [ ] **Plugin System** - Extensible plugin architecture for custom functionality
- [ ] **Asset Pipeline** - SCSS/SASS compilation, image optimization, minification
- [ ] **Live Reload** - Automatic browser refresh during development

### Content Management
- [ ] **Content Categories** - Support for categorizing posts and pages
- [ ] **Tags System** - Tagging support with tag pages generation
- [ ] **Draft Support** - Draft posts that don't appear in production builds
- [x] **Content Pagination** - Automatic pagination for large numbers of posts
- [ ] **Related Posts** - Automatic related post suggestions
- [ ] **Content Scheduling** - Future-dated posts that publish automatically

### Output and Performance
- [ ] **Multiple Output Formats** - Support for AMP, RSS/Atom feeds
- [ ] **SEO Optimization** - Automatic sitemap.xml, robots.txt generation
- [ ] **Performance Optimization** - Incremental builds, content caching
- [ ] **CDN Support** - Built-in support for CDN deployment
- [ ] **Image Processing** - Automatic image resizing and optimization

### Developer Experience
- [ ] **Watch Mode** - Automatic rebuilding on file changes
- [x] **Better Error Messages** - More descriptive error reporting with line numbers
- [x] **Content Validation** - Validate metadata and content structure
- [ ] **Template Debugging** - Better template error reporting and debugging
- [ ] **Hot Module Replacement** - Live editing without full page refresh

### Deployment and Integration
- [ ] **Deployment Commands** - Built-in deployment to GitHub Pages, Netlify, etc.
- [ ] **Git Integration** - Automatic commit and push after builds
- [ ] **CI/CD Templates** - Pre-configured GitHub Actions, GitLab CI templates
- [ ] **Docker Support** - Containerized builds and deployment
- [ ] **Static Analysis** - Content quality checks and link validation

### Advanced Features
- [ ] **Multi-language Support** - Internationalization and localization
- [ ] **Search Functionality** - Client-side search with index generation
- [ ] **Comment System** - Integration with external comment systems
- [ ] **Analytics Integration** - Built-in Google Analytics, privacy-focused alternatives
- [ ] **Social Media Integration** - Automatic social media meta tags and sharing

### Code Quality and Testing
- [x] **Comprehensive Test Suite** - Unit tests for all modules
- [ ] **Integration Tests** - End-to-end testing of CLI commands
- [ ] **Performance Benchmarks** - Build time and output size benchmarking
- [ ] **Code Documentation** - Complete API documentation with examples
- [ ] **Continuous Integration** - Automated testing and releases

## License

AGPL-3.0-or-later

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

---

*Generated with SSGD - A static site generator written in D*
