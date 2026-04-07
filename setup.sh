#!/bin/bash
# ============================================================
#  GREEN STREAK — One-time Setup Script
#  Run this ONCE to configure everything automatically.
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMIT_SCRIPT="$SCRIPT_DIR/auto_commit.sh"

echo ""
echo "🟩 Green Streak Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── Step 1: Config ───────────────────────────────────────────
echo ""
echo "Step 1: Configuration"
echo ""

read -p "  GitHub username: " GITHUB_USERNAME
read -p "  Repo name [green-streak]: " REPO_NAME
REPO_NAME="${REPO_NAME:-green-streak}"

read -p "  Project directory [$HOME/projects/green-streak]: " REPO_DIR
REPO_DIR="${REPO_DIR:-$HOME/projects/green-streak}"

read -p "  Commit time (24h, e.g. 09 for 9am) [09]: " COMMIT_HOUR
COMMIT_HOUR="${COMMIT_HOUR:-09}"

read -p "  Commit minute [00]: " COMMIT_MIN
COMMIT_MIN="${COMMIT_MIN:-00}"

# ── Step 2: Make script executable ──────────────────────────
echo ""
echo "Step 2: Setting up script"
chmod +x "$COMMIT_SCRIPT"
echo "  ✅ auto_commit.sh is executable"

# ── Step 3: Create config file ──────────────────────────────
CONFIG_FILE="$SCRIPT_DIR/.streak-config"
cat > "$CONFIG_FILE" << EOF
export GITHUB_USERNAME="$GITHUB_USERNAME"
export REPO_NAME="$REPO_NAME"
export GIT_STREAK_REPO="$REPO_DIR"
EOF
echo "  ✅ Config saved to .streak-config"

# ── Step 4: Install cron job ─────────────────────────────────
echo ""
echo "Step 3: Installing cron job (daily at ${COMMIT_HOUR}:${COMMIT_MIN})"

CRON_CMD="${COMMIT_MIN} ${COMMIT_HOUR} * * * source $CONFIG_FILE && bash $COMMIT_SCRIPT >> $SCRIPT_DIR/streak.log 2>&1"

# Remove old entry if exists, add new one
(crontab -l 2>/dev/null | grep -v "auto_commit.sh" ; echo "$CRON_CMD") | crontab -
echo "  ✅ Cron job installed"

# Show the cron entry
echo ""
echo "  Active cron entry:"
echo "  $CRON_CMD"

# ── Step 5: GitHub repo setup ────────────────────────────────
echo ""
echo "Step 4: GitHub Repository"
echo ""

if command -v gh &>/dev/null; then
  read -p "  Create GitHub repo automatically with gh CLI? [Y/n]: " CREATE_REPO
  if [[ "$CREATE_REPO" != "n" && "$CREATE_REPO" != "N" ]]; then
    mkdir -p "$REPO_DIR"
    cd "$REPO_DIR"

    # Run the commit script once to init
    source "$CONFIG_FILE"
    bash "$COMMIT_SCRIPT"

    gh repo create "$REPO_NAME" --public --source="$REPO_DIR" --remote=origin --push 2>/dev/null || \
      echo "  ⚠️  Repo may already exist, trying push..."
    cd "$REPO_DIR" && git push -u origin main 2>/dev/null || true
    echo "  ✅ Repo created: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
  fi
else
  echo "  gh CLI not found. Manual steps:"
  echo ""
  echo "  1. Run the script once to init the local repo:"
  echo "     source $CONFIG_FILE && bash $COMMIT_SCRIPT"
  echo ""
  echo "  2. Create repo on GitHub, then:"
  echo "     cd $REPO_DIR"
  echo "     git remote add origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
  echo "     git push -u origin main"
fi

# ── Done ─────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Green Streak is live!"
echo ""
echo "  📅 Commits daily at ${COMMIT_HOUR}:${COMMIT_MIN}"
echo "  📁 Repo: $REPO_DIR"
echo "  🌐 GitHub: https://github.com/$GITHUB_USERNAME/$REPO_NAME"
echo "  📋 Logs: $SCRIPT_DIR/streak.log"
echo ""
echo "  To test immediately:"
echo "  source $CONFIG_FILE && bash $COMMIT_SCRIPT"
echo ""
echo "  To view logs:"
echo "  tail -f $SCRIPT_DIR/streak.log"
echo ""
echo "  To remove the cron job:"
echo "  crontab -l | grep -v 'auto_commit.sh' | crontab -"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
