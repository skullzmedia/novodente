#!/bin/bash

# First, check if webp tools are installed
if ! command -v cwebp &> /dev/null; then
    echo "WebP tools not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Please install Homebrew first:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi
    brew install webp
fi

# Create output directory
mkdir -p compressed

# Initialize counter
count=0

# Process each image type
for img in *.{jpg,jpeg,png,gif,bmp}; do
    # Check if files exist (to handle case when no files of a type exist)
    [ -e "$img" ] || continue
    
    echo "Processing: $img"
    
    # Get original file size
    original_size=$(stat -f%z "$img")
    
    # Convert to WebP with optimal settings
    cwebp -q 80 -m 6 -sharp_yuv -v "$img" -o "compressed/${img%.*}.webp"
    
    # Get new file size
    new_size=$(stat -f%z "compressed/${img%.*}.webp")
    
    # Calculate reduction percentage
    reduction=$(( (original_size - new_size) * 100 / original_size ))
    
    echo "Size reduced by ${reduction}%"
    echo "Before: $(($original_size/1024))KB"
    echo "After: $(($new_size/1024))KB"
    echo "------------------------"
    
    ((count++))
done

echo "\nDone! Processed $count files."
echo "Compressed images are in the 'compressed' folder"