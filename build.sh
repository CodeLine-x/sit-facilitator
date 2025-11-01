#!/bin/bash
set -e

# Increase Node.js memory limit
export NODE_OPTIONS="--max-old-space-size=4096"

# Install pnpm if not already available
if ! command -v pnpm &> /dev/null; then
  echo "Installing pnpm..."
  npm install -g pnpm@10.7.0
fi

# Build the typescript packages
echo "Building typescript packages..."
cd typescript
pnpm install
pnpm build

# Install facilitator dependencies (tsx and other deps needed at runtime)
echo "Installing facilitator dependencies..."
cd ../examples/typescript
pnpm install

echo "Build complete!"

