#!/bin/bash
echo "🚀 Building production version..."
cd frontend
npm run build

echo "✅ Build completed, committing build folder..."
cd ..
git add frontend/build -f
git add frontend/package.json frontend/package-lock.json push-build.sh -f
git commit -m "🔄 Update frontend build"
git push origin main

echo "✅ Push completed!"