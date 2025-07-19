#!/bin/bash

echo "🚀 Building production version..."
cd frontend

npm install
npm run build

cd ..

echo "✅ Build completed, committing build folder..."

# Force add build output
git add frontend/build -f

# Add modified/new source files manually
echo "📦 Staging all modified + new files..."
git add frontend/package.json frontend/package-lock.json push-build.sh frontend/src/pages --force

echo "📝 Committing..."
git commit -m "🔄 Update build and source files"

echo "🚀 Pushing to GitHub..."
git push origin main

echo "✅ Push completed! Check deployment at Vercel..."