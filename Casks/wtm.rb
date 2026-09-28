cask "wtm" do
  version "3.1.0"
  sha256 "deeb4c3d0c53c29efbe08203a8347d20bda3c2864415e5a9187882ea7bb8d70a"

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
  #
  # `postflight_steps`, not a `postflight` block. Homebrew 7 deprecates the Ruby
  # blocks for declarative steps; official taps already reject them, and once the
  # deprecation becomes a hard error this cask would stop loading at all, taking
  # installs and upgrades with it. `{{appdir}}` is the step DSL's spelling of the
  # block's `#{appdir}`, resolved to wherever `--appdir` put the app.
  #
  # The step must succeed, where the old block ignored a failure. `xattr -dr` exits
  # 0 whether or not the attribute is present, so the only way it fails is an app
  # that is not where the `app` stanza put it — and an install that carries on from
  # there is the "installs, then will not start" outcome described above.
  #
  # This runs on `brew upgrade` as well as `brew install`, which is what lets wtm's
  # own Update and restart hand the upgrade to Homebrew without a second
  # Gatekeeper workaround of its own.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Worktree Manager.app"]
  end

  # Everything wtm writes lives in one XDG-style directory — config, the trust
  # store, and the log. A deliberate deviation from ~/Library/Application Support,
  # which is why `zap` names an unusual path for a Mac app.
  zap trash: "~/.config/wtm"

  caveats <<~CAVEATS
    wtm is not code-signed or notarized. This cask clears the quarantine attribute
    after installing, because macOS would otherwise refuse to open the app and
    report it as "damaged".

    If you would rather macOS made that decision, install the zip from the releases
    page by hand instead of using this tap.
  CAVEATS
end
