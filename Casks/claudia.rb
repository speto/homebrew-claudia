cask "claudia" do
  version "0.1.0"
  sha256 "95c943d7e4e3073123e1e6c5c046b6380f19c4b1635a754363108a1a82a0aacd"

  url "https://github.com/getAsterisk/claudia/releases/download/v#{version}/Claudia_v#{version}_macos_universal.dmg",
      verified: "github.com/getAsterisk/claudia/"

  name "Claudia"
  desc "Powerful GUI app and Toolkit for Claude Code"
  homepage "https://claudiacode.com/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: ">= :big_sur"

  app "Claudia.app"

  uninstall quit: "com.claudiacode.claudia"

  zap trash: [
    "~/Library/Application Support/com.claudiacode.claudia",
    "~/Library/Preferences/com.claudiacode.claudia.plist",
    "~/Library/Saved Application State/com.claudiacode.claudia.savedState",
    "~/Library/WebKit/com.claudiacode.claudia",
  ]
end