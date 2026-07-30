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
  # Symbol, not the ">= :ventura" string: Homebrew deprecated the string form and
  # now reads the bare symbol as a minimum.
  depends_on macos: :ventura

  app "Worktree Manager.app"

  # Clear the quarantine attribute Homebrew sets on every staged cask.
  #
  # This is a deliberate Gatekeeper bypass, so it deserves the space: wtm is
  # neither signed nor notarized, and macOS refuses to open a quarantined app that
  # is neither — reporting it as "damaged", which sounds like a corrupt download
  # rather than a missing $99/yr signature. Without this the cask installs
  # successfully and then produces an app that will not start, which is a worse
  # outcome than either working or failing.
  #
  # Homebrew used to offer `--no-quarantine` for exactly this. As of Homebrew 6 the
  # flag is rejected as an invalid option and the `HOMEBREW_CASK_OPTS` fallback is
  # dead code — `cask_opts_quarantine?` in env_config.rb has no callers. So a cask
  # for an unsigned app has no supported opt-out left, and this is the remaining
  # mechanism.
  #
  # What you are trusting is the tap, not this line: you already chose to install a
  # binary built by a GitHub Actions run from a public repository. The sha256 above
  # pins exactly which one.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Worktree Manager.app"],
                   print_stderr: false
  end

  # Everything wtm writes lives in one XDG-style directory — config, the trust
  # store, and the log. A deliberate deviation from ~/Library/Application Support,
  # which is why `zap` names an unusual path for a Mac app.
  zap trash: [
    "~/.config/wtm",
  ]

  caveats <<~CAVEATS
    wtm is not code-signed or notarized. This cask clears the quarantine attribute
    after installing, because macOS would otherwise refuse to open the app and
    report it as "damaged".

    If you would rather macOS made that decision, install the zip from the releases
    page by hand instead of using this tap.
  CAVEATS
end
