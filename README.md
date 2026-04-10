# ⚡ commit-auto

> Automate your Git commits with smart messages, scheduled pushes, and zero friction.

---

## What It Does

`commit-auto` watches your working directory, stages changed files, generates meaningful commit messages, and pushes to your remote — on a schedule or on demand.

No more "fix stuff" commit messages. No more forgetting to push before a meeting.

---

## Features

- 🤖 **AI-generated commit messages** — describes what actually changed, not just "update files"
- 🕐 **Scheduled auto-push** — commit and push at set intervals (cron-compatible)
- 📂 **Selective staging** — include/exclude paths via config
- 🔒 **Branch guard** — prevent accidental pushes to `main`/`master`
- 📋 **Commit log** — local record of every automated commit with timestamps
- 🔔 **Webhook notifications** — ping Slack, Discord, or any endpoint on push

---

## Installation

```bash
# Clone the repo
git clone https://github.com/your-username/commit-auto.git
cd commit-auto

# Install dependencies
npm install

# Link globally (optional)
npm link
```

---

## Quick Start

```bash
# Initialize in your project
commit-auto init

# Run once manually
commit-auto run

# Start the scheduler (every 30 minutes)
commit-auto watch --interval 30m
```

---

## Configuration

Create a `commit-auto.config.json` in your project root:

```json
{
  "branch": "dev",
  "interval": "30m",
  "include": ["src/", "scripts/"],
  "exclude": ["node_modules/", ".env", "*.log"],
  "messageStyle": "conventional",
  "pushOnCommit": true,
  "notify": {
    "slack": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
  }
}
```

### Config Options

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `branch` | string | current branch | Branch to commit to |
| `interval` | string | `"1h"` | How often to auto-commit (`30m`, `1h`, `6h`) |
| `include` | array | `["."]` | Paths to include in staging |
| `exclude` | array | `[]` | Paths to exclude |
| `messageStyle` | string | `"conventional"` | `conventional`, `short`, or `verbose` |
| `pushOnCommit` | boolean | `true` | Auto-push after committing |
| `notify` | object | `{}` | Webhook endpoints for notifications |

---

## Commit Message Styles

### `conventional`
```
feat(src): add spatial join function to pipeline utils
fix(scripts): resolve null reference in batch processor
chore: update 3 config files
```

### `short`
```
update src/pipeline.py, scripts/run.sh
```

### `verbose`
```
Modified 4 files in src/:
- Added interpolation logic to raster_utils.py
- Refactored batch handler in processor.py
- Updated path resolution in config.py
- Minor whitespace cleanup in __init__.py
```

---

## CLI Reference

```bash
commit-auto init                     # Set up config in current directory
commit-auto run                      # Stage, commit, and push once
commit-auto watch                    # Start scheduler from config
commit-auto watch --interval 15m     # Override interval
commit-auto status                   # Show pending changes + last commit
commit-auto log                      # View local automation log
commit-auto stop                     # Stop the running scheduler
commit-auto config --show            # Print current config
```

---

## Workflows

### Pair with a cron job (Linux/macOS)

```bash
# Add to crontab — commit every hour at :00
0 * * * * cd /path/to/your/project && commit-auto run
```

### GitHub Actions integration

```yaml
# .github/workflows/auto-commit.yml
name: Auto Commit

on:
  schedule:
    - cron: '0 */6 * * *'

jobs:
  commit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: npm install -g commit-auto
      - run: commit-auto run
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

---

## Environment Variables

```env
COMMIT_AUTO_TOKEN=ghp_your_personal_access_token
COMMIT_AUTO_AI_KEY=your_anthropic_or_openai_key   # For AI message generation
COMMIT_AUTO_BRANCH=dev
```

---

## Safety Rules

- **Never runs on `main` or `master`** unless explicitly overridden with `--force-branch`
- **Skips empty diffs** — won't create empty commits
- **Dry-run mode** available: `commit-auto run --dry-run` shows what would happen without doing it
- **Rollback**: `commit-auto rollback` undoes the last automated commit (soft reset)

---

## Roadmap

- [ ] GUI dashboard (Electron)
- [ ] Multi-repo support
- [ ] GitHub PR auto-creation on feature branch completion
- [ ] Diff summarization via local LLM (Ollama)
- [ ] VS Code extension

---

## Contributing

PRs welcome. Please open an issue first for major changes.

```bash
git clone https://github.com/your-username/commit-auto.git
cd commit-auto
npm install
npm test
```

---

## License

MIT © 2026
