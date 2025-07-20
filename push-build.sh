#!/bin/bash

set -e

# ⏱️ เริ่มจับเวลา
start_time=$(date +%s)

echo "🚦 Starting push-build.sh..."

# ✅ ตรวจว่าอยู่บน branch main
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" ]]; then
  echo "❌ You are on branch '$current_branch'. Please switch to 'main' before pushing."
  exit 1
fi

# 🔄 ดึงของล่าสุดจาก remote ด้วย rebase
echo "🔄 Pulling latest changes from origin/main..."
git pull origin main --rebase || {
  echo "❌ Pull failed. Resolve conflicts first."
  exit 1
}

echo "📦 Installing dependencies..."
cd frontend
npm install
npm audit fix --force || true
echo "🚀 Building production version..."
npm run --prefix frontend build | tee -a build-log.txt
cd ..

# 📦 Add ไฟล์ใหม่หรือไฟล์ที่เปลี่ยนแปลงทั้งหมด
echo "📦 Staging all modified + new files..."
git add -A

# 📝 Commit ถ้ามีการเปลี่ยนแปลง
if git diff --cached --quiet; then
  echo "📭 Nothing to commit. Working tree clean."
else
  echo "📝 Committing..."
  git commit -m "🔄 Update build and source files"
fi

# 🚀 Push ขึ้น GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

# 🔗 ลิงก์หน้า Vercel
echo "✅ Push completed! Visit: https://movc-dashboard.vercel.app/"

# ⏱️ แสดงเวลาที่ใช้
end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
echo "⏱️ Done in $elapsed seconds."