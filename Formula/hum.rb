class Hum < Formula
  desc "Terminal media player for local music, YouTube Music, and podcasts"
  homepage "https://github.com/zblauser/hum"
  version "0.1.8"
  license "MIT"

  head do
    url "https://github.com/zblauser/hum.git", branch: "main"
    depends_on "zig" => :build
  end

  depends_on "mpv"
  depends_on "yt-dlp"

  # Prebuilt: no Intel-mac zig bottle exists, and zig from source means LLVM from source.
  on_macos do
    url "https://github.com/zblauser/hum/releases/download/v0.1.8/hum-macos-universal.tar.gz"
    sha256 "PLACEHOLDER"
  end

  on_linux do
    on_intel do
      url "https://github.com/zblauser/hum/releases/download/v0.1.8/hum-linux-x86_64.tar.gz"
      sha256 "PLACEHOLDER"
    end
    on_arm do
      url "https://github.com/zblauser/hum/releases/download/v0.1.8/hum-linux-arm64.tar.gz"
      sha256 "PLACEHOLDER"
    end
  end

  def install
    if build.head?
      system "zig", "build",
             "--prefix", prefix,
             "--global-cache-dir", buildpath/".zig-global",
             "-Doptimize=ReleaseSafe",
             "-Dmpv-prefix=#{Formula["mpv"].opt_prefix}"
    else
      bin.install "hum"
      # brew's mpv links brew's glibc; the binary must load through brew's ld.so to use it
      ld_so = HOMEBREW_PREFIX/"lib/ld.so"
      (bin/"hum").patch!(interpreter: ld_so.to_s) if OS.linux? && ld_so.exist?
    end
  end

  test do
    assert_match "hum #{version}", shell_output("#{bin}/hum --version")
  end
end
