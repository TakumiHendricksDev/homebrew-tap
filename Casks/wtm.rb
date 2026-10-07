cask "wtm" do
  version "4.0.0"
  sha256 "a5d52370a47ba47622237d6a915db16a3baddd67c68cddfcd062f6bbd68035f7"

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
  # Since 3.1.0, wtm is signed with a Developer ID and notarized by Apple, so
  # Gatekeeper opens it without this. What the step saves now is macOS's one-time
  # "downloaded from the Internet" confirmation, after every install and every
  # upgrade. That matters most when wtm's own Update and restart relaunches the app:
  # without this step, the relaunch would stop at that dialog.
  #
  # Before 3.1.0 the step was load-bearing. macOS refuses to open a quarantined app
  # that is neither signed nor notarized, and reports it as "damaged", which reads
  # like a corrupt download. Homebrew's `--no-quarantine` used to cover that case,
  # but as of Homebrew 6 the flag is rejected and the `HOMEBREW_CASK_OPTS` fallback
  # is dead code, which is why the cask does it itself.
  #
  # What you are trusting is the tap, not this line: you already chose to install a
  # binary built by a GitHub Actions run from a public repository. The sha256 above
  # pins exactly which one, and its Developer ID signature says who built it.
  #
  # `postflight_steps`, not a `postflight` block. Homebrew 7 deprecates the Ruby
  # blocks for declarative steps; official taps already reject them, and once the
  # deprecation becomes a hard error this cask would stop loading at all, taking
  # installs and upgrades with it. `{{appdir}}` is the step DSL's spelling of the
  # block's `#{appdir}`, resolved to wherever `--appdir` put the app.
  #
  # The step must succeed, where the old block ignored a failure. `xattr -dr` exits
  # 0 whether or not the attribute is present, so the only way it fails is an app
  # that is not where the `app` stanza put it. An install that carried on from
  # there would report success with nothing usable installed.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Worktree Manager.app"]
  end

  # Everything wtm writes lives in one XDG-style directory — config, the trust
  # store, and the log. A deliberate deviation from ~/Library/Application Support,
  # which is why `zap` names an unusual path for a Mac app.
  zap trash: "~/.config/wtm"

  caveats <<~CAVEATS
    wtm is signed and notarized. This cask also clears the quarantine attribute
    after installing and upgrading, which skips macOS's one-time "downloaded from
    the Internet" confirmation.

    If you would rather see that confirmation, install the zip from the releases
    page by hand instead of using this tap.
  CAVEATS
end
