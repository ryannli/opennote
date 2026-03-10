#!/bin/bash
set -e

echo "Setting up OpenNote..."

# Check prerequisites
if ! command -v gh &> /dev/null; then
  echo "Error: GitHub CLI (gh) is required. Install it: https://cli.github.com/"
  exit 1
fi

if ! gh auth status &> /dev/null; then
  echo "Error: Please authenticate GitHub CLI first: gh auth login"
  exit 1
fi

# Check we're in a git repo
if ! git rev-parse --is-inside-work-tree &> /dev/null; then
  echo "Error: Not inside a git repository. Clone this repo first."
  exit 1
fi

REPO=$(git remote get-url origin 2>/dev/null | sed 's|.*github.com[:/]||;s|\.git$||' || true)

if [ -z "$REPO" ]; then
  echo "Error: Could not detect GitHub repo. Make sure this repo has a remote."
  exit 1
fi

echo "Repo: $REPO"

# Detect and configure timezone
if [ -L /etc/localtime ]; then
  TIMEZONE=$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')
elif [ -f /etc/timezone ]; then
  TIMEZONE=$(cat /etc/timezone)
else
  TIMEZONE=$(date +%Z)
fi

if [ -n "$TIMEZONE" ]; then
  sed -i.bak "s|TIMEZONE_PLACEHOLDER|$TIMEZONE|" CLAUDE.md && rm -f CLAUDE.md.bak
  echo "Timezone configured: $TIMEZONE"
else
  echo "Warning: Could not detect timezone. Please update CLAUDE.md manually."
fi

# Configure GitHub Actions write permissions (needed for auto-merge workflow)
echo "Configuring GitHub Actions write permissions..."
gh api "repos/$REPO/actions/permissions/workflow" \
  -X PUT -f default_workflow_permissions=write -F can_approve_pull_request_reviews=false \
  2>/dev/null && echo "Actions permissions configured" \
  || echo "Warning: Could not set Actions permissions. You may need to do this manually in Settings > Actions > General."

echo ""
echo "Setup complete! Start capturing:"
echo "  claude \"your thought here\""
