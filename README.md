# homebrew-tap

Homebrew formulae and casks for my own tools. This repository holds **recipes only** —
no binaries. Each cask is a few lines naming a download URL and its SHA-256; the
artifacts themselves live on the releases page of the project they belong to.

## Casks

### [wtm](https://github.com/TakumiHendricksDev/worktreemanager) — Worktree Manager

A desktop app for managing git worktrees across projects. Worktrees as tabs down the
left, details and a live terminal on the right, and a **New Worktree** form each
project defines for itself in a `wtm.toml`.

```bash
brew install --cask takumihendricksdev/tap/wtm
```

**wtm is signed with a Developer ID and notarized by Apple** (since 3.1.0), so
Gatekeeper accepts it like any other downloaded app.

The cask also clears the quarantine attribute after installing, and again after every
upgrade. For a notarized app that only skips macOS's one-time *"downloaded from the
Internet"* confirmation. Before 3.1.0 wtm was unsigned, and the same step was the only
reason it opened at all. If you would rather see the confirmation, download the zip
from the [releases page](https://github.com/TakumiHendricksDev/worktreemanager/releases)
by hand instead of using this tap.

Apple silicon and macOS 13+. There is no Linux build any more: the AppImage was
dropped after v1.2.0.

## Updating

```bash
brew update && brew upgrade --cask wtm
```

## Removing

```bash
brew uninstall --cask wtm          # the app
brew uninstall --zap --cask wtm    # the app plus ~/.config/wtm
```
