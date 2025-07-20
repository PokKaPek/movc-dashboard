#!/bin/bash
echo "📏 Checking build size..."
BUILD_PATH="frontend/build"

if [ ! -d "$BUILD_PATH" ]; then
  echo "❌ Build folder not found: $BUILD_PATH"
  exit 1
fi

SIZE_MB=$(du -sm "$BUILD_PATH" | cut -f1)
MAX_MB=5

echo "📦 Build size: ${SIZE_MB}MB"

if [ "$SIZE_MB" -gt "$MAX_MB" ]; then
  echo "⚠️ Warning: Build size exceeds ${MAX_MB}MB!"
else
  echo "✅ Build size is within acceptable range."
fi