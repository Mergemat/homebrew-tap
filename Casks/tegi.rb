# Rendered into Mergemat/homebrew-tap as Casks/tegi.rb by
# .github/workflows/release.yml.
cask "tegi" do
  version "0.3.3"
  sha256 "51e31a66dd5aa20436d5b84bffeb69e252ce775de74df022a8c92f7dc2025cc3"

  url "https://github.com/Mergemat/tegi/releases/download/v#{version}/tegi-#{version}.zip"
  name "tegi"
  desc "Scrollable tiling window manager"
  homepage "https://github.com/Mergemat/tegi"

  depends_on macos: :sonoma

  app "tegi.app"
  binary "#{appdir}/tegi.app/Contents/MacOS/tegi"

  postflight_steps do
    # The app is signed ad hoc, not notarized; Homebrew already checked the
    # download against the sha256 above.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/tegi.app"]
    # Start right away, and again after an upgrade quit the old version.
    run "/usr/bin/open", args: ["{{appdir}}/tegi.app"], must_succeed: false
  end

  uninstall quit: "io.github.mergemat.tegi"

  zap trash: "~/.config/tegi"

  caveats <<~EOS
    tegi asks for Accessibility (to move windows) and Screen Recording (for
    workspace slides and the overview) on first launch, and starts at login.
  EOS
end
