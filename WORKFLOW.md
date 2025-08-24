# 🚀 Hugo Site Workflow Guide

This guide explains how to easily update and deploy your cybersecurity portfolio site using GitHub Actions.

## 📝 **Quick Workflow (3 Steps)**

### **Step 1: Sync from Obsidian**
```bash
./sync-obsidian.sh
```
This copies your updated content from Obsidian to the Hugo site.

### **Step 2: Deploy via GitHub Actions**
```bash
./deploy.sh
```
This builds locally, pushes to main, and triggers automatic GitHub Actions deployment.

### **Step 3: Monitor Deployment**
Check the GitHub Actions tab to see your site being built and deployed automatically.

---

## 🔄 **Detailed Workflow**

### **Option A: Full Automated Workflow**
```bash
# 1. Sync from Obsidian
./sync-obsidian.sh

# 2. Deploy (automatically commits, pushes, and triggers GitHub Actions)
./deploy.sh
```

### **Option B: Manual Control**
```bash
# 1. Sync from Obsidian
./sync-obsidian.sh

# 2. Review changes
git status

# 3. Add and commit
git add content/posts/
git commit -m "Update cybersecurity content"
git push origin main

# 4. GitHub Actions will automatically deploy!
```

---

## 📁 **What Each Script Does**

### **`sync-obsidian.sh`**
- ✅ Copies all `.md` files from Obsidian to Hugo
- ✅ Shows what files were copied
- ✅ Checks git status for changes
- ✅ Provides next steps guidance

### **`deploy.sh`**
- ✅ Checks you're on main branch
- ✅ Prompts to commit uncommitted changes
- ✅ Builds Hugo site locally to verify it works
- ✅ Pushes to main branch to trigger GitHub Actions
- ✅ Opens GitHub Actions page (optional)

---

## 🌐 **Your Site URLs**

- **Local Development**: `http://localhost:1313/`
- **Production**: `https://h232ch.github.io/portfolio/`

---

## 🛠 **Local Development**

```bash
# Start development server
hugo server --bind 0.0.0.0 --port 1313 --liveReloadPort 1314

# Build for production (local verification)
hugo --minify
```

---

## 📚 **Content Management**

### **Adding New Posts**
1. Create new `.md` file in Obsidian
2. Add front matter:
   ```markdown
   ---
   title: "Your Post Title"
   date: 2025-08-24
   tags: ["cybersecurity", "siem", "aws"]
   draft: false
   ---
   
   Your content here...
   ```
3. Run `./sync-obsidian.sh`
4. Deploy with `./deploy.sh`

### **Updating Existing Posts**
1. Edit in Obsidian
2. Run `./sync-obsidian.sh`
3. Deploy with `./deploy.sh`

---

## 🚀 **GitHub Actions Deployment**

### **How It Works**
1. **Push to main branch** triggers GitHub Actions workflow
2. **Workflow builds** your Hugo site on GitHub's servers
3. **Automatic deployment** to GitHub Pages
4. **No manual branch switching** required

### **Benefits**
- ✅ **Faster deployment** (2-5 minutes vs manual)
- ✅ **No local build artifacts** to manage
- ✅ **Automatic from main branch** - just push and deploy
- ✅ **Built-in CI/CD** with GitHub's infrastructure

---

## 🔧 **Troubleshooting**

### **If sync fails:**
- Check Obsidian path in `sync-obsidian.sh`
- Ensure Obsidian vault is accessible

### **If deployment fails:**
- Check GitHub Actions tab for error messages
- Verify Hugo build works locally first
- Check for syntax errors in your content

### **If site doesn't update:**
- Wait 2-5 minutes for GitHub Actions to complete
- Check GitHub Actions tab for deployment status
- Verify workflow completed successfully

---

## 🎯 **Pro Tips**

1. **Always sync before deploying** - ensures latest content
2. **Use descriptive commit messages** - helps track changes
3. **Test locally first** - run `hugo server` to preview
4. **Keep Obsidian organized** - use consistent file naming
5. **Monitor GitHub Actions** - check deployment status

---

## 📞 **Need Help?**

- Check Hugo documentation: https://gohugo.io/documentation/
- GitHub Pages docs: https://pages.github.com/
- GitHub Actions docs: https://docs.github.com/en/actions
- PaperMod theme: https://github.com/adityatelange/hugo-PaperMod

---

**Happy blogging with automated deployment! 🎉**
