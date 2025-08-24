#!/bin/bash

# Deploy script for Hugo site to GitHub Pages
# Make sure you have a gh-pages branch set up

echo "🚀 Building Hugo site..."
hugo --minify

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Check if gh-pages branch exists
    if git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
        echo "📁 Deploying to gh-pages branch..."
        
        # Switch to gh-pages branch
        git checkout gh-pages
        
        # Remove old files (except .git)
        find . -maxdepth 1 ! -name '.' ! -name '..' ! -name '.git' ! -name '.gitignore' -exec rm -rf {} +
        
        # Copy new files from public directory
        cp -r public/* .
        
        # Add all changes
        git add .
        
        # Commit changes
        git commit -m "Deploy site $(date)"
        
        # Push to gh-pages branch
        git push origin gh-pages
        
        # Switch back to main branch
        git checkout main
        
        echo "🎉 Deployment complete! Your site should be available at https://h232ch.github.io/"
    else
        echo "❌ gh-pages branch not found. Please create it first:"
        echo "   git checkout -b gh-pages"
        echo "   git push origin gh-pages"
        echo "   Then run this script again."
    fi
else
    echo "❌ Build failed!"
    exit 1
fi
