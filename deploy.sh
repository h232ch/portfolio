#!/bin/bash

# Deploy script for Hugo site to GitHub Pages
# This script automates the deployment process

set -e  # Exit on any error

echo "🚀 Starting Hugo site deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Safety check: Ensure we're in the right directory
if [[ ! -f "hugo.toml" ]]; then
    print_error "hugo.toml not found! Please run this script from the Hugo project root directory."
    exit 1
fi

# Check if we're on main branch
if [[ $(git branch --show-current) != "main" ]]; then
    print_error "You must be on the main branch to deploy!"
    print_status "Current branch: $(git branch --show-current)"
    print_status "Please run: git checkout main"
    exit 1
fi

# Check if there are uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
    print_warning "You have uncommitted changes!"
    print_status "Current git status:"
    git status --short
    
    read -p "Do you want to commit these changes before deploying? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Committing changes..."
        git add .
        read -p "Enter commit message: " commit_msg
        git commit -m "${commit_msg:-"Update site content"}"
        print_success "Changes committed!"
    else
        print_error "Please commit or stash your changes before deploying!"
        exit 1
    fi
fi

# Build the Hugo site
print_status "Building Hugo site..."
if ! hugo --minify; then
    print_error "Hugo build failed!"
    exit 1
fi

# Safety check: Ensure public directory was created and contains files
if [[ ! -d "public" ]] || [[ -z "$(ls -A public 2>/dev/null)" ]]; then
    print_error "Hugo build failed to create public directory or it's empty!"
    exit 1
fi

print_success "Site built successfully!"

# Check if gh-pages branch exists
if ! git show-ref --verify --quiet refs/remotes/origin/gh-pages; then
    print_error "gh-pages branch not found on remote!"
    print_status "Creating gh-pages branch..."
    git checkout -b gh-pages
    git push origin gh-pages
    git checkout main
    print_success "gh-pages branch created!"
fi

# Create a temporary directory for the build
TEMP_BUILD_DIR=$(mktemp -d)
print_status "Created temporary build directory: $TEMP_BUILD_DIR"

# Copy built site to temporary directory
print_status "Copying built site to temporary directory..."
cp -r public/* "$TEMP_BUILD_DIR/"

# Switch to gh-pages branch
print_status "Switching to gh-pages branch..."
git checkout gh-pages

# Safety check: Ensure we're on gh-pages branch
if [[ $(git branch --show-current) != "gh-pages" ]]; then
    print_error "Failed to switch to gh-pages branch!"
    rm -rf "$TEMP_BUILD_DIR"
    exit 1
fi

# Clean the gh-pages branch safely (keep only .git and .nojekyll)
print_status "Cleaning gh-pages branch..."
# Only remove files, not directories, to be safer
find . -maxdepth 1 -type f ! -name '.nojekyll' -delete
# Remove directories safely
find . -maxdepth 1 -type d ! -name '.' ! -name '..' ! -name '.git' ! -name '.nojekyll' -exec rm -rf {} + 2>/dev/null || true

# Copy new site files from temporary directory
print_status "Copying new site files..."
cp -r "$TEMP_BUILD_DIR"/* .

# Clean up temporary directory
rm -rf "$TEMP_BUILD_DIR"

# Add all changes
print_status "Adding changes to git..."
git add .

# Commit changes
print_status "Committing deployment..."
git commit -m "Deploy site $(date '+%Y-%m-%d %H:%M:%S')"

# Push to gh-pages branch
print_status "Pushing to gh-pages branch..."
git push origin gh-pages

# Switch back to main branch
print_status "Switching back to main branch..."
git checkout main

# Safety check: Ensure we're back on main branch
if [[ $(git branch --show-current) != "main" ]]; then
    print_error "Failed to switch back to main branch!"
    exit 1
fi

# Clean up public directory
print_status "Cleaning up..."
rm -rf public

print_success "🎉 Deployment complete!"
print_success "Your site should be available at: https://h232ch.github.io/portfolio/"
print_status "Note: It may take a few minutes for changes to appear."

# Optional: Open the site in browser
read -p "Do you want to open the site in your browser? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Opening site in browser..."
    open "https://h232ch.github.io/portfolio/"
fi
