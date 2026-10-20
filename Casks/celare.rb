# Rendered into Mergemat/homebrew-tap as Casks/celare.rb by
# .github/workflows/release.yml.
cask "celare" do
  version "0.1.1"
  sha256 "01d6ac1de6f7ca999ee1c6b7283e6d8a77f1213a10044722afa6f995e7cbb5a3"

  url "https://github.com/Mergemat/celare/releases/download/v#{version}/Celare-#{version}.zip"
  name "celare"
  desc "Agent-friendly VPN client for every protocol 3x-ui serves"
  homepage "https://github.com/Mergemat/celare"

  depends_on macos: :sonoma

  app "Celare.app"
  binary "#{appdir}/Celare.app/Contents/Resources/celare"

  postflight_steps do
    # The app is signed ad hoc, not notarized; Homebrew already checked the
    # download against the sha256 above.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Celare.app"]
    # Install (or, on upgrade, replace) the background service. If this is
    # skipped, the app offers the same step on first launch.
    run "{{appdir}}/Celare.app/Contents/Resources/celare",
        args:         ["service", "install"],
        sudo:         true,
        must_succeed: false
  end

  uninstall script: {
              executable:   "#{appdir}/Celare.app/Contents/Resources/celare",
              args:         ["service", "uninstall"],
              sudo:         true,
              must_succeed: false,
            },
            quit:   "sh.celare.app"

  zap trash: [
    "/Library/Application Support/celare",
    "/Library/Logs/celare",
    "~/.config/celare",
  ]
end
