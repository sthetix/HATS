#!/bin/bash

# Move HATS-08122025-6fd71fe.zip to the top of releases
# by deleting and recreating it

TAG="HATS-08122025-6fd71fe.zip"

echo "Fetching release data for $TAG..."
release=$(gh api repos/sthetix/HATS/releases/tags/$TAG)

# Extract release info
name=$(echo "$release" | jq -r '.name')
body=$(echo "$release" | jq -r '.body')

# Download the asset
echo "Downloading asset..."
asset_url=$(echo "$release" | jq -r '.assets[0].browser_download_url')
asset_name=$(echo "$release" | jq -r '.assets[0].name')
curl -L -o "/tmp/$asset_name" "$asset_url"

echo "Deleting old release..."
gh release delete "$TAG" --yes

echo "Recreating release at the top..."
gh release create "$TAG" --title "$name" --notes "$body" "/tmp/$asset_name"

echo "Done! $TAG is now at the top."
