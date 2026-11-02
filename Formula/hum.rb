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
    sha256 "5eee6cf675b5aeb868d6333d24c825296dbb50c64b7d8953ec96326e507305c5"
  end

  on_linux do
    on_intel do
      url "https://github.com/zblauser/hum/releases/download/v0.1.8/hum-linux-x86_64.tar.gz"
      sha256 "413e9f8fb020d62c592fb7e102136f851c561084d76d09364ed29af686fa1f93"
    end
    on_arm do
      url "https://github.com/zblauser/hum/releases/download/v0.1.8/hum-linux-arm64.tar.gz"
      sha256 "6b3dc44385a6ce92633dc2bca35872d4355fd846121bf884a525e54bd2909b0e"
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
