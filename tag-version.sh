#!/bin/bash
echo "🏷️ Tagging version..."
VERSION="v$(date +%Y.%m.%d-%H%M)"
git tag "$VERSION"
git push origin "$VERSION"
echo "✅ Tagged as $VERSION"