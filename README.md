# Sean's Tech Notes - Cybersecurity Portfolio

A modern, automated Hugo-based portfolio website showcasing cybersecurity expertise, detection engineering, SOC operations, and vulnerability management.

## 🏗️ **Architecture Overview**

### **Technology Stack**
- **Static Site Generator**: Hugo (v0.148.2+)
- **Theme**: PaperMod (clean, responsive design)
- **Hosting**: GitHub Pages
- **CI/CD**: GitHub Actions
- **Content Management**: Obsidian + Git workflow
- **Build Process**: Automated Hugo build and deployment

### **Project Structure**
```
cybersecurity-project/
├── content/
│   └── posts/          # Blog posts and cybersecurity content
├── themes/
│   └── PaperMod/       # Hugo theme (Git submodule)
├── static/             # Static assets (images, CSS, JS)
├── layouts/            # Custom layouts (if needed)
├── hugo.toml          # Hugo configuration
├── .github/
│   └── workflows/      # GitHub Actions deployment
├── deploy.sh           # Automated deployment script
├── sync-obsidian.sh    # Obsidian content sync script
└── README.md           # This file
```

## 🚀 **Deployment Architecture**

### **GitHub Actions Workflow**
The site uses a **two-stage deployment process**:

1. **Build Stage** (`build` job):
   - Checks out code with submodules
   - Sets up Hugo environment
   - Builds Hugo site with production settings
   - Uploads built site as artifact

2. **Deploy Stage** (`deploy` job):
   - Takes built site from build stage
   - Deploys to GitHub Pages infrastructure
   - Makes site live at `https://h232ch.github.io/portfolio/`

### **Configuration Files**
- **`hugo.toml`**: Main Hugo configuration
  - `baseURL`: Set to GitHub Pages URL
  - `mainSections = ["posts"]`: Defines content structure
  - `theme = "PaperMod"`: Clean, professional theme
  - Server settings for local development

## 🔄 **Content Workflow**

### **Content Management Process**
```
Obsidian Vault → Sync Script → Hugo Site → Git Commit → Auto-Deploy
      ↓              ↓           ↓         ↓         ↓
   Edit Content   ./sync-obsidian.sh   Review   git commit   Live Site
```

### **Automation Scripts**

#### **`sync-obsidian.sh`**
- **Purpose**: Syncs content from Obsidian vault to Hugo
- **Source**: `/Users/sehwankim/Library/Mobile Documents/iCloud~md~obsidian/Documents/sean/Portfolio/posts`
- **Destination**: `content/posts/`
- **Safety**: Only copies `.md` files, never deletes
- **Features**: 
  - Path validation
  - File counting
  - Git status checking
  - Clear feedback

#### **`deploy.sh`**
- **Purpose**: Automated deployment via GitHub Actions
- **Safety Features**:
  - Directory validation (`hugo.toml` check)
  - Branch validation (must be on `main`)
  - Change detection and handling
  - Local build verification
  - Cleanup of temporary files
- **Process**:
  1. Validates environment
  2. Handles uncommitted changes
  3. Builds locally to catch errors
  4. Pushes to main branch
  5. Triggers GitHub Actions deployment

## 🌐 **Deployment Process**

### **Local Development**
```bash
# Start development server
hugo server --bind 0.0.0.0 --port 1313 --liveReloadPort 1314

# Build for production
hugo --minify
```

### **Production Deployment**
```bash
# Option 1: Use automation scripts (Recommended)
./sync-obsidian.sh    # Sync content from Obsidian
./deploy.sh           # Deploy via GitHub Actions

# Option 2: Manual deployment
git add .
git commit -m "Update content"
git push origin main
```

### **Deployment Timeline**
1. **Push to main**: Triggers GitHub Actions
2. **Build phase**: Hugo site builds (2-3 minutes)
3. **Deploy phase**: GitHub Pages deployment (3-5 minutes)
4. **Live site**: Available at `https://h232ch.github.io/portfolio/`

## 🔧 **Configuration Details**

### **Hugo Configuration (`hugo.toml`)**
```toml
baseURL = "https://h232ch.github.io/portfolio/"
title = "Sean's Tech Notes"
theme = "PaperMod"

[params]
  defaultTheme = "auto"
  [params.homeInfoParams]
    Title = "Welcome 👋"
    Content = "Cybersecurity • Detection Engineering • SOC • Vulnerability"
  mainSections = ["posts"]  # Critical: tells Hugo where to find posts

[outputs]
  home = ["HTML", "RSS", "JSON"]  # Enables search and RSS

[taxonomies]
  tag = "tags"           # Tag-based categorization
  category = "categories" # Category-based organization
```

### **GitHub Actions Configuration (`.github/workflows/deploy.yml`)**
- **Triggers**: Push to `main` branch
- **Permissions**: Pages write, ID token access
- **Concurrency**: Prevents overlapping deployments
- **Environment**: GitHub Pages deployment environment

## 🛡️ **Security Features**

### **Script Safety**
- **Path validation**: Prevents directory traversal
- **Error handling**: Graceful failure on errors
- **User confirmation**: Asks before important actions
- **No destructive operations**: Scripts only copy/add, never delete user files

### **Deployment Security**
- **GitHub Actions**: Runs in isolated environment
- **No secrets exposure**: Uses GitHub's built-in security
- **Branch protection**: Only deploys from `main` branch

## 📊 **Monitoring and Troubleshooting**

### **GitHub Actions Monitoring**
- **URL**: `https://github.com/h232ch/portfolio/actions`
- **Status**: Shows build and deployment progress
- **Logs**: Detailed logs for troubleshooting

### **Common Issues and Solutions**

#### **Site Shows README Instead of Posts**
- **Cause**: `mainSections` configuration issue
- **Solution**: Ensure `mainSections = ["posts"]` in `hugo.toml`

#### **Deployment Not Triggered**
- **Cause**: No new commits pushed
- **Solution**: Make a change and push to trigger workflow

#### **Local Works But GitHub Doesn't**
- **Cause**: Configuration differences between local and production
- **Solution**: Check `hugo.toml` settings, especially `baseURL` and `mainSections`

## 🎯 **Key Benefits of This Architecture**

1. **Automation**: Zero manual deployment steps
2. **Reliability**: GitHub Actions handles all infrastructure
3. **Security**: No manual server access needed
4. **Scalability**: Easy to add content and features
5. **Professional**: Industry-standard CI/CD pipeline
6. **Content-First**: Easy content management via Obsidian
7. **Version Control**: Full Git history of all changes

## 🔗 **Useful Links**

- **Live Site**: [https://h232ch.github.io/portfolio/](https://h232ch.github.io/portfolio/)
- **GitHub Repository**: [https://github.com/h232ch/portfolio](https://github.com/h232ch/portfolio)
- **GitHub Actions**: [https://github.com/h232ch/portfolio/actions](https://github.com/h232ch/portfolio/actions)
- **Hugo Documentation**: [https://gohugo.io/documentation/](https://gohugo.io/documentation/)
- **PaperMod Theme**: [https://github.com/adityatelange/hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## 🎉 **Getting Started**

1. **Clone the repository**
2. **Install Hugo**: `brew install hugo` (macOS)
3. **Start local development**: `hugo server`
4. **Edit content**: Use Obsidian or any markdown editor
5. **Deploy**: Run `./deploy.sh` or push to main branch

---

**Built with ❤️ using Hugo, PaperMod theme, and GitHub Actions**

*This architecture provides a professional, automated, and scalable way to maintain a cybersecurity portfolio website with zero manual deployment steps.*
