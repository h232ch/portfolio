# 🚀 Hugo Site Workflow Guide

This guide explains how to easily update and deploy your cybersecurity portfolio site.

## 📝 **Quick Workflow (3 Steps)**

### **Step 1: Sync from Obsidian**
```bash
./sync-obsidian.sh
```
This copies your updated content from Obsidian to the Hugo site.

### **Step 2: Commit Changes**
```bash
git add content/posts/
git commit -m "Update content from Obsidian"
git push origin main
```

### **Step 3: Deploy to GitHub Pages**
```bash
./deploy.sh
```
This builds and deploys your site automatically.

---

## 🔄 **Detailed Workflow**

### **Option A: Full Automated Workflow**
```bash
# 1. Sync from Obsidian
./sync-obsidian.sh

# 2. Deploy (automatically commits and pushes)
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

# 4. Deploy
./deploy.sh
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
- ✅ Builds Hugo site with minification
- ✅ Deploys to gh-pages branch
- ✅ Switches back to main branch
- ✅ Opens site in browser (optional)

---

## 🌐 **Your Site URLs**

- **Local Development**: `http://localhost:1313/`
- **Production**: `https://h232ch.github.io/portfolio/`

---

## 🛠 **Local Development**

```bash
# Start development server
hugo server --bind 0.0.0.0 --port 1313 --liveReloadPort 1314

# Build for production
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

## 🔧 **Troubleshooting**

### **If sync fails:**
- Check Obsidian path in `sync-obsidian.sh`
- Ensure Obsidian vault is accessible

### **If deployment fails:**
- Make sure you're on main branch
- Check for uncommitted changes
- Verify Hugo is installed

### **If site doesn't update:**
- Wait 1-3 minutes for GitHub Pages
- Check gh-pages branch on GitHub
- Verify `.nojekyll` file exists

---

## 🎯 **Pro Tips**

1. **Always sync before deploying** - ensures latest content
2. **Use descriptive commit messages** - helps track changes
3. **Test locally first** - run `hugo server` to preview
4. **Keep Obsidian organized** - use consistent file naming

---

## 📞 **Need Help?**

- Check Hugo documentation: https://gohugo.io/documentation/
- GitHub Pages docs: https://pages.github.com/
- PaperMod theme: https://github.com/adityatelange/hugo-PaperMod

---

**Happy blogging! 🎉**
