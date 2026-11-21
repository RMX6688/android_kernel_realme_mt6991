#!/usr/bin/env bash
# Re-import the upstream GKI snapshot into kernel-6.6/.
#
# The vendor half is this repo's own root history, so it is updated with
#   git fetch realme-vendor master && git merge --no-edit realme-vendor/master
set -euo pipefail
cd "$(dirname "$0")/.."

branch=${1:-master}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

git clone --depth=1 --branch "$branch" \
  https://github.com/realme-kernel-opensource/realme_gt7-AndroidB-kernel-source.git "$tmp/kernel"
rev=$(git -C "$tmp/kernel" rev-parse --short=12 HEAD)

rm -rf kernel-6.6
mkdir kernel-6.6
git -C "$tmp/kernel" archive HEAD | tar -x -C kernel-6.6

git add -A kernel-6.6
if git diff --cached --quiet; then
  echo "kernel-6.6 already up to date ($rev)"
  exit 0
fi
git commit -m "kernel-6.6: sync GKI snapshot to $rev"
echo "kernel-6.6 -> $rev"
