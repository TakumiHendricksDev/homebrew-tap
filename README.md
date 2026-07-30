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
brew install --cask --no-quarantine takumihendricksdev/tap/wtm
```

**`--no-quarantine` is not optional.** wtm is unsigned and un-notarized, so without it
macOS refuses to open the app and reports it as *"damaged and can't be opened"* —
which is Gatekeeper's message for *"this came from the internet and nobody paid Apple
to vouch for it"*, not a statement about the download. Signing it properly needs a paid
Apple Developer account; until that exists, the flag is how you say you trust it.

Apple silicon and macOS 13+. On Linux, grab the AppImage from the
[releases page](https://github.com/TakumiHendricksDev/worktreemanager/releases)
instead — Homebrew is not the right delivery mechanism there.

## Updating

```bash
brew update && brew upgrade --cask wtm
```

## Removing

```bash
brew uninstall --cask wtm          # the app
brew uninstall --zap --cask wtm    # the app plus ~/.config/wtm
```
