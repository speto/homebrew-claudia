#!/usr/bin/env bash
set -euo pipefail

owner="getAsterisk"
repo="claudia"
cask_file="Casks/claudia.rb"

echo "Checking for updates to Claudia..."

# Get the most recent release from GitHub API
json=$(curl -s "https://api.github.com/repos/$owner/$repo/releases" | jq -r '.[0]')
tag=$(jq -r '.tag_name' <<<"$json" | sed 's/^v//')

if [ "$tag" = "null" ] || [ -z "$tag" ]; then
  echo "Error: Could not fetch latest version from GitHub"
  echo "API response: $json"
  exit 1
fi

# Get current version from cask file
current_version=$(grep "version " "$cask_file" | grep -o '"[^"]*"' | tr -d '"')

echo "Current version: $current_version"
echo "Latest version: $tag"

if [ "$tag" != "$current_version" ]; then
  echo "New version available: $tag"
  
  # Construct download URL
  download_url="https://github.com/$owner/$repo/releases/download/v$tag/Claudia_v${tag}_macos_universal.dmg"
  
  echo "Download URL: $download_url"
  
  # Download the file to calculate SHA256
  temp_file=$(mktemp)
  echo "Downloading file to calculate checksum..."
  if ! curl -sL "$download_url" -o "$temp_file"; then
    echo "Error: Could not download file from $download_url"
    rm -f "$temp_file"
    exit 1
  fi
  
  # Calculate SHA256
  new_sha256=$(shasum -a 256 "$temp_file" | cut -d' ' -f1)
  echo "New SHA256: $new_sha256"
  
  # Clean up temp file
  rm -f "$temp_file"
  
  # Update the cask file using a temporary file approach
  echo "Updating cask file..."
  
  tmp="$(mktemp)"
  
  awk -v ver="$tag" -v sha="$new_sha256" '
    # Update version line
    /^[[:space:]]*version[[:space:]]+"/ {
      print "  version \"" ver "\""
      next
    }
    
    # Update sha256 line
    /^[[:space:]]*sha256[[:space:]]+"/ {
      print "  sha256 \"" sha "\""
      next
    }
    
    # Print all other lines as-is
    { print }
  ' "$cask_file" > "$tmp"
  
  # Validate the file has proper Ruby syntax
  if ruby -c "$tmp" 2>/dev/null; then
    mv "$tmp" "$cask_file"
    echo "Successfully updated $cask_file to version $tag"
    echo "Version: $current_version -> $tag"
    echo "SHA256: $new_sha256"
  else
    echo "Error: Generated cask file has syntax errors"
    cat "$tmp"
    rm "$tmp"
    exit 1
  fi
else
  echo "Already up to date: $current_version"
fi