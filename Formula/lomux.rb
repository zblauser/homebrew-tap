class Lomux < Formula
  desc "Lightweight media converter with FFmpeg and yt-dlp integration"
  homepage "https://github.com/zblauser/LoMux"
  url "https://github.com/zblauser/LoMux/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "4ac5a7b7fc9bc3a95d1eeb366bd7c9ae837e52b7ea86c37f2f78fcd8a8f571f9"
  license "MIT"
  head "https://github.com/zblauser/LoMux.git", branch: "main"

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "LoMux #{version}", shell_output("#{bin}/lomux --version")
  end
end
