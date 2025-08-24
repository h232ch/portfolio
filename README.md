# Sean's Tech Notes - Cybersecurity Portfolio

A Hugo-based portfolio website showcasing cybersecurity expertise, data pipelines, and OCSF knowledge.

## 🚀 Quick Start

### Local Development
```bash
# Start the development server
hugo server --bind 0.0.0.0 --port 1313 --liveReloadPort 1314

# Open http://localhost:1313 in your browser
```

### Build for Production
```bash
# Build the site
hugo --minify

# The built site will be in the `public/` directory
```

## 📁 Project Structure

```
cybersecurity-project/
├── content/
│   └── posts/          # Blog posts and content
├── themes/
│   └── PaperMod/       # Hugo theme
├── static/             # Static assets
├── layouts/            # Custom layouts (if any)
├── hugo.toml          # Hugo configuration
└── .github/
    └── workflows/      # GitHub Actions for deployment
```

## 🌐 Deployment to GitHub Pages

### Option 1: Automatic Deployment (Recommended)

1. **Push your code to GitHub**:
   ```bash
   git add .
   git commit -m "Initial portfolio setup"
   git push origin main
   ```

2. **Enable GitHub Pages**:
   - Go to your repository on GitHub
   - Navigate to Settings → Pages
   - Under "Source", select "GitHub Actions"
   - The GitHub Actions workflow will automatically deploy your site

3. **Your site will be available at**: `https://h232ch.github.io/`

### Option 2: Manual Deployment

1. **Build the site**:
   ```bash
   hugo --minify
   ```

2. **Deploy to GitHub Pages**:
   - Create a new branch called `gh-pages`
   - Copy the contents of the `public/` directory to the root of the `gh-pages` branch
   - Push the `gh-pages` branch to GitHub
   - Enable GitHub Pages from the `gh-pages` branch in repository settings

## 🔧 Configuration

The main configuration is in `hugo.toml`:

- **baseURL**: Set to your GitHub Pages URL for production
- **theme**: Uses PaperMod theme
- **mainSections**: Configured to show posts from the `content/posts/` directory

## 📝 Adding Content

1. **Create new posts** in `content/posts/`:
   ```markdown
   ---
   title: "Your Post Title"
   date: 2025-08-24
   tags: ["cybersecurity", "siem", "aws"]
   draft: false
   ---
   
   Your content here...
   ```

2. **Use Hugo front matter** for metadata:
   - `title`: Post title
   - `date`: Publication date
   - `tags`: Array of tags for categorization
   - `draft`: Set to `false` to publish

## 🎨 Customization

- **Theme**: The site uses the PaperMod theme
- **Styling**: Custom CSS can be added to `assets/css/`
- **Layouts**: Custom layouts can be added to `layouts/`

## 📚 Hugo Commands

```bash
# Development server
hugo server

# Build site
hugo

# Build with minification
hugo --minify

# Build drafts
hugo --buildDrafts

# Help
hugo help
```

## 🔗 Useful Links

- [Hugo Documentation](https://gohugo.io/documentation/)
- [PaperMod Theme](https://github.com/adityatelange/hugo-PaperMod)
- [GitHub Pages](https://pages.github.com/)

---

Built with ❤️ using Hugo and PaperMod theme
# Updated at Sun Aug 24 13:23:33 KST 2025
