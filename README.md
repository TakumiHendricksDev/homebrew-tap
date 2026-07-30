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

**wtm is unsigned and un-notarized**, so macOS would normally refuse to open it and
report it as *"damaged and can't be opened"* — Gatekeeper's message for *"this came
from the internet and nobody paid Apple to vouch for it"*, not a statement about the
download. The cask therefore clears the quarantine attribute after installing.

That is a deliberate Gatekeeper bypass and you should know it is happening. Homebrew
used to expose `--no-quarantine` for this; as of Homebrew 6 the flag is rejected and
the `HOMEBREW_CASK_OPTS` path is dead code, so a cask for an unsigned app has no
supported opt-out left. If you would rather macOS made the call, download the zip from
the [releases page](https://github.com/TakumiHendricksDev/worktreemanager/releases)
by hand instead of using this tap.

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
