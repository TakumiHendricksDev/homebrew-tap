cask "wtm" do
  version "0.1.0"
  sha256 "7c498b73601de3184eef3ed2e3c79106744c64d18ed4dbbcf12d4a42296d0c92"

  url "https://github.com/TakumiHendricksDev/worktreemanager/releases/download/v#{version}/wtm-#{version}-macos-arm64.zip"
  name "Worktree Manager"
  desc "Manage git worktrees across projects"
  homepage "https://github.com/TakumiHendricksDev/worktreemanager"

  # Lets `brew livecheck` (and anyone auditing the tap) see when this cask has
  # fallen behind the upstream release without opening the repo.
  livecheck do
    url :url
    strategy :github_latest
  end

  # Apple silicon only: CI builds a single aarch64 binary. Building universal is
  # possible (`just build-universal`) but roughly doubles build time for a second
  # architecture nobody has asked for yet.
  depends_on arch: :arm64
  # macOS 13, matching `bundle.macOS.minimumSystemVersion` in tauri.conf.json.
  depends_on macos: ">= :ventura"

  app "Worktree Manager.app"

  # Everything wtm writes lives in one XDG-style directory — config, the trust
  # store, and the log. A deliberate deviation from ~/Library/Application Support,
  # which is why `zap` names an unusual path for a Mac app.
  zap trash: [
    "~/.config/wtm",
  ]

  caveats <<~CAVEATS
    wtm is not code-signed or notarized, so Homebrew's quarantine will stop it
    from opening. Install it with:

      brew install --cask --no-quarantine takumihendricksdev/tap/wtm

    If you already installed it without that flag, either reinstall as above or
    clear the attribute by hand:

      xattr -dr com.apple.quarantine "/Applications/Worktree Manager.app"
  CAVEATS
end
