#!/bin/bash

# Deploy script for Hugo site using GitHub Actions
# This script builds the site and pushes to main branch to trigger GitHub Actions deployment

set -e  # Exit on any error

echo "🚀 Starting Hugo site deployment via GitHub Actions..."

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

# Build the Hugo site locally to verify it works
print_status "Building Hugo site locally to verify build..."
if ! hugo --minify; then
    print_error "Hugo build failed! Please fix build issues before deploying."
    exit 1
fi

# Safety check: Ensure public directory was created and contains files
if [[ ! -d "public" ]] || [[ -z "$(ls -A public 2>/dev/null)" ]]; then
    print_error "Hugo build failed to create public directory or it's empty!"
    exit 1
fi

print_success "Local build successful! Site will be built and deployed by GitHub Actions."

# Clean up local build
print_status "Cleaning up local build files..."
rm -rf public

# Push to main branch to trigger GitHub Actions deployment
print_status "Pushing to main branch to trigger GitHub Actions deployment..."
git push origin main

print_success "🎉 Deployment triggered!"
print_success "GitHub Actions will now build and deploy your site."
print_status "Check deployment status at: https://github.com/h232ch/portfolio/actions"
print_status "Your site will be available at: https://h232ch.github.io/portfolio/"
print_status "Note: Deployment usually takes 2-5 minutes."

# Optional: Open the GitHub Actions page
read -p "Do you want to open the GitHub Actions page? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Opening GitHub Actions page..."
    open "https://github.com/h232ch/portfolio/actions"
fi
