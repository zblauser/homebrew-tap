# zblauser/homebrew-tap

Homebrew formulas

```sh
brew tap zblauser/tap
```

| Formula | What | Install |
|---|---|---|
| `hum` | Terminal media player — local library, YouTube Music, podcasts | `brew install zblauser/tap/hum` |
| `lomux` | Media converter and YouTube downloader with an egui GUI | `brew install zblauser/tap/lomux` |

`hum` installs its prebuilt release binary (no zig, no compiling) and pulls in `mpv`; `--HEAD` builds from source with `zig`. `lomux` builds from source with `rust` and needs `ffmpeg`.

