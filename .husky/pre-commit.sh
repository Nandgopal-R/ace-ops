#!/usr/bin/env bash
# .husky/pre-commit.sh

# Define the unwanted lock files
unwanted_files=("package-lock.json" "pnpm-lock.yaml" "bun.lockb")

# Check for unwanted lock files in the staged changes
for file in "${unwanted_files[@]}"; do
  if git diff --cached --name-only | grep -qE "^$file$"; then
    echo "Error: Commits containing '$file' are not allowed. Please use Yarn and remove this file from your commit."
    exit 1
  fi
done

# Allow yarn.lock (not mandatory, but no other lock files allowed)
if git diff --cached --name-only | grep -qE "^yarn\.lock$"; then
  echo "yarn.lock is allowed."
else
  # No lock file is fine, but warn if other lock files are present
  if git diff --cached --name-only | grep -qE "\.lock(b)?$"; then
    echo "Error: Only 'yarn.lock' is allowed as a lock file. Please remove other lock files from your commit."
    exit 1
  fi
done
