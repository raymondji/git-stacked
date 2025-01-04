#!/bin/bash
set -e

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Error: Your working directory has uncommitted changes. Please commit or stash them before running this script."
  exit 1
fi

go build ./...
go test ./...
go install ./cmd/git-stack
CLI_VERSION=$(git stack version)
if git rev-parse "$CLI_VERSION" >/dev/null 2>&1; then
  echo "Tag '$CLI_VERSION' already exists."
  exit 1
fi

SAMPLE_FILE=$(mktemp)
git stack learn --chapter 1 --mode=exec > "$SAMPLE_FILE"
git checkout main
git stack learn --chapter 1 --mode=clean

go run release/generate_template.go --template readme --version "$CLI_VERSION" --sample-output "$SAMPLE_FILE"
git add .
git commit -m "Release $CLI_VERSION"
git push
git tag "$CLI_VERSION"
git push origin "$CLI_VERSION"