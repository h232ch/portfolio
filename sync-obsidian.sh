#!/bin/bash

# Sync script to copy content from Obsidian vault to Hugo site
# This makes it easy to update your site from Obsidian

set -e  # Exit on any error

echo "🔄 Syncing content from Obsidian..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
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

# Obsidian vault path
OBSIDIAN_PATH="/Users/sehwankim/Library/Mobile Documents/iCloud~md~obsidian/Documents/sean/Portfolio/posts"

# Hugo content path
HUGO_PATH="content/posts"

# Check if Obsidian path exists
if [[ ! -d "$OBSIDIAN_PATH" ]]; then
    print_warning "Obsidian posts directory not found at: $OBSIDIAN_PATH"
    print_status "Please update the OBSIDIAN_PATH variable in this script."
    exit 1
fi

# Check if Hugo content directory exists
if [[ ! -d "$HUGO_PATH" ]]; then
    print_status "Creating Hugo content directory..."
    mkdir -p "$HUGO_PATH"
fi

# Copy all markdown files from Obsidian to Hugo
print_status "Copying files from Obsidian to Hugo..."
cp "$OBSIDIAN_PATH"/*.md "$HUGO_PATH/"

# Count copied files
file_count=$(ls -1 "$HUGO_PATH"/*.md 2>/dev/null | wc -l | tr -d ' ')

if [[ $file_count -gt 0 ]]; then
    print_success "Copied $file_count markdown file(s) from Obsidian!"
    
    # Show what was copied
    print_status "Files copied:"
    ls -la "$HUGO_PATH"/*.md
    
    # Check git status
    print_status "Checking git status..."
    if [[ -n $(git status --porcelain) ]]; then
        print_status "Changes detected! You can now:"
        print_status "1. Review changes: git status"
        print_status "2. Add changes: git add content/posts/"
        print_status "3. Commit: git commit -m 'Update content from Obsidian'"
        print_status "4. Deploy: ./deploy.sh"
    else
        print_status "No changes detected in git."
    fi
else
    print_warning "No markdown files found to copy."
fi

print_success "Sync complete! 🎉"
