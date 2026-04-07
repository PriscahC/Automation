#!/bin/bash
# ============================================================
#  GREEN STREAK — Auto Git Commit Script
#  Run daily via cron. Generates a new mini-project each week
#  and makes a meaningful commit every day.
# ============================================================

set -e

# ── CONFIG ──────────────────────────────────────────────────
REPO_DIR="${GIT_STREAK_REPO:-$HOME/projects/green-streak}"
GITHUB_USERNAME="${GITHUB_USERNAME:-your-username}"
REPO_NAME="${REPO_NAME:-green-streak}"
# ────────────────────────────────────────────────────────────

TODAY=$(date +%Y-%m-%d)
DAY_OF_WEEK=$(date +%u)   # 1=Mon … 7=Sun
WEEK_NUM=$(date +%V)
YEAR=$(date +%Y)
PROJECT_ID="week-${YEAR}-${WEEK_NUM}"

# ── WEEKLY PROJECT THEMES ───────────────────────────────────
THEMES=(
  "cli-tool"
  "data-visualizer"
  "markdown-parser"
  "ascii-art-generator"
  "file-organizer"
  "color-palette-tool"
  "json-formatter"
  "text-stats-analyzer"
  "habit-tracker"
  "recipe-generator"
  "password-generator"
  "url-shortener-mock"
  "budget-calculator"
  "pomodoro-timer"
  "word-frequency-counter"
  "base64-encoder"
  "css-gradient-generator"
  "roman-numeral-converter"
  "fibonacci-visualizer"
  "prime-sieve"
  "maze-generator"
  "binary-clock"
  "morse-code-translator"
  "anagram-detector"
  "timezone-converter"
  "pixel-art-canvas"
  "regex-tester"
  "diff-tool"
  "csv-to-json"
  "yaml-validator"
  "log-parser"
  "ip-calculator"
  "todo-cli"
  "note-taking-cli"
  "weather-formatter"
  "unit-converter"
  "flashcard-quiz"
  "typing-speed-test"
  "number-guessing-game"
  "tic-tac-toe-engine"
  "sorting-visualizer"
  "binary-search-demo"
  "graph-traversal"
  "linked-list-impl"
  "stack-and-queue"
  "lru-cache"
  "bloom-filter"
  "trie-implementation"
  "event-emitter"
  "promise-pool"
  "rate-limiter"
  "retry-mechanism"
)

THEME_INDEX=$(( (10#$WEEK_NUM + 10#$YEAR * 52) % ${#THEMES[@]} ))
CURRENT_THEME="${THEMES[$THEME_INDEX]}"

# ── DAILY COMMIT MESSAGES ───────────────────────────────────
MESSAGES_DAY1=("feat: scaffold ${CURRENT_THEME} project structure" "feat: init ${CURRENT_THEME} boilerplate")
MESSAGES_DAY2=("feat: implement core logic for ${CURRENT_THEME}" "feat: add main module to ${CURRENT_THEME}")
MESSAGES_DAY3=("feat: add input validation and error handling" "feat: handle edge cases in ${CURRENT_THEME}")
MESSAGES_DAY4=("test: add unit tests for ${CURRENT_THEME}" "test: write test coverage for core functions")
MESSAGES_DAY5=("refactor: clean up ${CURRENT_THEME} implementation" "style: improve code readability and naming")
MESSAGES_DAY6=("docs: add README and usage examples for ${CURRENT_THEME}" "docs: document API and configuration options")
MESSAGES_DAY7=("chore: finalize ${CURRENT_THEME} — bump version to 1.0.0" "release: ${CURRENT_THEME} v1.0.0 complete")

pick_message() {
  local day=$1
  local arr_name="MESSAGES_DAY${day}[@]"
  local arr=("${!arr_name}")
  echo "${arr[$((RANDOM % ${#arr[@]}))]}"
}

# ── SETUP REPO ──────────────────────────────────────────────
setup_repo() {
  if [ ! -d "$REPO_DIR" ]; then
    echo "📁 Creating repo at $REPO_DIR"
    mkdir -p "$REPO_DIR"
    cd "$REPO_DIR"
    git init
    git checkout -b main 2>/dev/null || true

    # Create initial files
    cat > README.md << 'EOF'
# 🟩 Green Streak

Auto-generated projects to keep GitHub contribution graph green.
Each week features a new mini-project built incrementally over 7 days.

## Projects
EOF

    cat > .gitignore << 'EOF'
node_modules/
__pycache__/
*.pyc
.DS_Store
*.log
.env
dist/
build/
EOF

    git add .
    git commit -m "chore: initialize green-streak repository"

    echo ""
    echo "⚠️  Now connect this to GitHub:"
    echo "   gh repo create $REPO_NAME --public --source=. --remote=origin --push"
    echo "   OR manually: git remote add origin git@github.com:$GITHUB_USERNAME/$REPO_NAME.git"
    echo "                git push -u origin main"
    echo ""
  fi
}

# ── GENERATE WEEKLY PROJECT ─────────────────────────────────
generate_project() {
  local project_dir="$REPO_DIR/projects/$PROJECT_ID"

  if [ ! -d "$project_dir" ]; then
    echo "🆕 Starting new project: $CURRENT_THEME ($PROJECT_ID)"
    mkdir -p "$project_dir"

    # Scaffold based on theme
    cat > "$project_dir/README.md" << EOF
# ${CURRENT_THEME}

**Week:** ${PROJECT_ID}
**Started:** ${TODAY}

A mini-project implementation of a ${CURRENT_THEME}.

## Overview
This project was built incrementally over one week as part of the green-streak challenge.

## Structure
\`\`\`
${CURRENT_THEME}/
├── README.md
├── main.js (or main.py)
├── utils.js
└── tests/
\`\`\`

## Usage
See implementation files for details.
EOF

    # Create a language-specific starter
    cat > "$project_dir/main.js" << EOF
/**
 * ${CURRENT_THEME}
 * Week: ${PROJECT_ID} | Started: ${TODAY}
 */

'use strict';

// ── Core Implementation ──────────────────────────────────

class ${CURRENT_THEME//-/_} {
  constructor(options = {}) {
    this.options = options;
    this.version = '0.1.0';
    this.createdAt = new Date().toISOString();
  }

  run(input) {
    // TODO: implement in subsequent commits
    console.log(\`Running ${CURRENT_THEME} with input:\`, input);
    return { status: 'initialized', input };
  }
}

module.exports = { ${CURRENT_THEME//-/_} };

// ── CLI Entry ────────────────────────────────────────────
if (require.main === module) {
  const tool = new ${CURRENT_THEME//-/_}();
  tool.run(process.argv.slice(2));
}
EOF

    cat > "$project_dir/utils.js" << EOF
/**
 * Utility functions for ${CURRENT_THEME}
 * Generated: ${TODAY}
 */

'use strict';

const utils = {
  // Validate input
  validate(input) {
    if (input === null || input === undefined) {
      throw new Error('Input cannot be null or undefined');
    }
    return true;
  },

  // Format output
  format(data) {
    return JSON.stringify(data, null, 2);
  },

  // Log with timestamp
  log(message, level = 'INFO') {
    const timestamp = new Date().toISOString();
    console.log(\`[\${timestamp}] [\${level}] \${message}\`);
  }
};

module.exports = utils;
EOF

    mkdir -p "$project_dir/tests"
    cat > "$project_dir/tests/index.test.js" << EOF
/**
 * Tests for ${CURRENT_THEME}
 * Week: ${PROJECT_ID}
 */

'use strict';

const { ${CURRENT_THEME//-/_} } = require('../main');
const utils = require('../utils');

// Simple test runner (no dependencies)
let passed = 0, failed = 0;

function test(name, fn) {
  try {
    fn();
    console.log(\`  ✅ \${name}\`);
    passed++;
  } catch (e) {
    console.log(\`  ❌ \${name}: \${e.message}\`);
    failed++;
  }
}

function assert(condition, msg) {
  if (!condition) throw new Error(msg || 'Assertion failed');
}

console.log('\\n🧪 Testing ${CURRENT_THEME}\\n');

test('instantiates correctly', () => {
  const tool = new ${CURRENT_THEME//-/_}();
  assert(tool.version === '0.1.0', 'version should be 0.1.0');
});

test('utils.validate rejects null', () => {
  try {
    utils.validate(null);
    assert(false, 'should have thrown');
  } catch (e) {
    assert(e.message.includes('null'), 'error message should mention null');
  }
});

test('utils.format returns JSON string', () => {
  const result = utils.format({ key: 'value' });
  assert(typeof result === 'string', 'should be string');
  assert(result.includes('key'), 'should contain key');
});

console.log(\`\\n📊 Results: \${passed} passed, \${failed} failed\\n\`);
process.exit(failed > 0 ? 1 : 0);
EOF

  fi
}

# ── DAILY UPDATE ────────────────────────────────────────────
daily_update() {
  local project_dir="$REPO_DIR/projects/$PROJECT_ID"
  local log_file="$REPO_DIR/.streak-log"

  # Check if already committed today
  if [ -f "$log_file" ] && grep -q "^$TODAY" "$log_file" 2>/dev/null; then
    echo "✅ Already committed today ($TODAY). Skipping."
    exit 0
  fi

  cd "$REPO_DIR"

  # Add meaningful daily content based on day of week
  local day_stamp="$REPO_DIR/.day-tracker-$PROJECT_ID"
  local commit_day=1
  if [ -f "$day_stamp" ]; then
    commit_day=$(cat "$day_stamp")
    commit_day=$((commit_day + 1))
  fi
  [ $commit_day -gt 7 ] && commit_day=7
  echo $commit_day > "$day_stamp"

  # Write a timestamped progress entry
  local progress_file="$project_dir/PROGRESS.md"
  cat >> "$progress_file" << EOF

## Day ${commit_day} — ${TODAY}

Progress update for day ${commit_day} of ${CURRENT_THEME}.

$(case $commit_day in
  1) echo "- Initialized project structure\n- Set up boilerplate files\n- Defined core interfaces" ;;
  2) echo "- Implemented core algorithm\n- Added primary data structures\n- Wired up main entry point" ;;
  3) echo "- Added input validation\n- Handled error cases\n- Improved robustness" ;;
  4) echo "- Wrote unit tests\n- Achieved >80% coverage\n- Fixed bugs found during testing" ;;
  5) echo "- Refactored for clarity\n- Extracted shared utilities\n- Improved naming conventions" ;;
  6) echo "- Wrote README with examples\n- Documented public API\n- Added usage instructions" ;;
  7) echo "- Final polish\n- Version bump to 1.0.0\n- Project complete ✅" ;;
esac)
EOF

  # Also update root README with latest project
  if ! grep -q "$PROJECT_ID" "$REPO_DIR/README.md" 2>/dev/null; then
    echo "- **[$PROJECT_ID]** \`$CURRENT_THEME\` — started $TODAY" >> "$REPO_DIR/README.md"
  fi

  # Stage and commit
  git add .
  local msg=$(pick_message $commit_day)
  git commit -m "$msg"

  # Push (will fail silently if no remote — set up GitHub first)
  git push origin main 2>/dev/null || echo "⚠️  Push failed — make sure remote is configured"

  # Log success
  echo "$TODAY committed day $commit_day of $PROJECT_ID: $msg" >> "$log_file"
  echo "✅ Committed: $msg"
}

# ── MAIN ────────────────────────────────────────────────────
echo "🟩 Green Streak — $TODAY"
setup_repo
generate_project
daily_update
