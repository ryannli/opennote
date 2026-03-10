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
  echo "Error: Not inside a git repository."
  echo ""
  echo "Quick start:"
  echo "  git clone https://github.com/ryannli/opennote.git my-notes"
  echo "  cd my-notes"
  echo "  ./setup.sh"
  exit 1
fi

# Detect if this is still pointing to the template repo
ORIGIN_URL=$(git remote get-url origin 2>/dev/null || true)
IS_TEMPLATE=false

if echo "$ORIGIN_URL" | grep -q "ryannli/opennote"; then
  IS_TEMPLATE=true
fi

# If still pointing to template, create a private repo and switch remote
if [ "$IS_TEMPLATE" = true ]; then
  echo ""
  echo "This repo is still linked to the public template."
  echo "Creating a private repo for your notes..."
  echo ""

  # Prompt for repo name
  read -p "Repo name (default: opennote): " REPO_NAME
  REPO_NAME=${REPO_NAME:-opennote}

  # Create private repo on GitHub
  if gh repo view "$REPO_NAME" &>/dev/null 2>&1; then
    echo "Repo $REPO_NAME already exists. Switching remote..."
    NEW_URL=$(gh repo view "$REPO_NAME" --json url -q '.url')
  else
    echo "Creating private repo: $REPO_NAME"
    gh repo create "$REPO_NAME" --private --source=. --push
    NEW_URL=$(gh repo view "$REPO_NAME" --json url -q '.url')
  fi

  # Keep template as upstream for future updates
  git remote rename origin upstream 2>/dev/null || true
  git remote add origin "$NEW_URL" 2>/dev/null || git remote set-url origin "$NEW_URL"
  git push -u origin main
  echo "Remote switched to private repo: $NEW_URL"
  echo "Template kept as 'upstream' — pull updates with: git pull upstream main"
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
  # Also replace timezone placeholder in skill files
  find .claude/skills -name "SKILL.md" -exec sed -i.bak "s|TIMEZONE_PLACEHOLDER|$TIMEZONE|" {} \; -exec rm -f {}.bak \;
  echo "Timezone configured: $TIMEZONE"
else
  echo "Warning: Could not detect timezone. Please update CLAUDE.md and skill files manually."
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
