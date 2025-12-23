#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting Yazi installation (Static Musl Build)..."

# 1. Update and install dependencies
apt-get update
apt-get install -y ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick curl unzip

# 2. Get latest version tag from GitHub API
LATEST_TAG=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name":' | cut -d '"' -f 4)

# 3. Determine Architecture (Using Musl for compatibility)
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    FILE="yazi-x86_64-unknown-linux-musl.zip"
elif [ "$ARCH" = "aarch64" ]; then
    FILE="yazi-aarch64-unknown-linux-musl.zip"
else
    echo "❌ Unsupported architecture: $ARCH"
    exit 1
fi

# 4. Download
URL="https://github.com/sxyazi/yazi/releases/download/${LATEST_TAG}/${FILE}"
echo "📥 Downloading Yazi $LATEST_TAG..."
curl -LO "$URL"

# 5. Extract and Install
unzip -q "$FILE"
mv "${FILE%.zip}/yazi" "${FILE%.zip}/ya" /usr/local/bin/

# 6. Cleanup
rm -rf "$FILE" "${FILE%.zip}"

echo "✅ Yazi $(yazi --version) installed successfully!"