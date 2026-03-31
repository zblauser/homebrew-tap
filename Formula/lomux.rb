class Lomux < Formula
  desc "Lightweight media converter with FFmpeg and yt-dlp integration"
  homepage "https://github.com/zblauser/LoMux"
  url "https://github.com/zblauser/LoMux/archive/v1.1.0.tar.gz"
  sha256 "PLACEHOLDER_UPDATE_AFTER_RELEASE"
  license "GPL-3.0-only"

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "LoMux", shell_output("#{bin}/lomux --help 2>&1", 1)
  end
end
