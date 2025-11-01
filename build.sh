#!/bin/bash
set -e

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

# Build the examples
echo "Building examples..."
cd ../examples/typescript
pnpm install
pnpm build

echo "Build complete!"

