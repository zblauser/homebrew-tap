class Hum < Formula
  desc "Terminal media player for your local library and YouTube Music"
  homepage "https://github.com/zblauser/hum"
  url "https://github.com/zblauser/hum/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "16c6e8aa30561b5532f9fd4498ea2407b183bd33f62d8b3e0bc52e84e32bcff4"
  license "MIT"
  head "https://github.com/zblauser/hum.git", branch: "main"

  depends_on "zig" => :build
  depends_on "mpv" 
  depends_on "yt-dlp"

  def install
    system "zig", "build",
           "--prefix", prefix,
           "--global-cache-dir", buildpath/".zig-global",
           "-Doptimize=ReleaseSafe",
           "-Dmpv-prefix=#{Formula["mpv"].opt_prefix}"
  end

  test do
    assert_match "hum #{version}", shell_output("#{bin}/hum --version")
  end
end
