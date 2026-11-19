# Written by release/write-package-manifests.mjs in erden-sh/erden from release/pins/0.1.0.json, and updated
# by its release workflow. Do not edit by hand.
class Erden < Formula
  desc "Check, package and publish ontologies with the Erden registry"
  homepage "https://erden.sh"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/erden-sh/erden/releases/download/v0.1.0/erden-0.1.0-darwin-arm64.tar.gz"
      sha256 "1781313f263f6734c2808bf5b0a286f35ed946a1adfd1a0f41377ac67d40058c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/erden-sh/erden/releases/download/v0.1.0/erden-0.1.0-linux-arm64.tar.gz"
      sha256 "9ac75830f17a05bfd248d9178148bd236abcefe1fa0764a40fde9f8ec09ad647"
    end
    on_intel do
      url "https://github.com/erden-sh/erden/releases/download/v0.1.0/erden-0.1.0-linux-x64.tar.gz"
      sha256 "2a794171fa7078d4df21386c498819e22867a8456709d2e9c2994ab9afb437b0"
    end
  end

  depends_on arch: :arm64 if OS.mac?

  # The engines check their own SHA-256 before every run, so nothing in the archive may be rewritten.
  skip_clean "libexec"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/erden", libexec/"bin/den"
    if (libexec/"lib/dist/completions.js").exist?
      generate_completions_from_executable(bin/"erden", "completions")
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/erden --version").strip
    assert_equal shell_output("#{bin}/erden help"), shell_output("#{bin}/den help")
    doctor = JSON.parse(shell_output("#{bin}/erden doctor --json"))
    assert_equal "passed", doctor["outcome"]
    system bin/"erden", "init", testpath/"project", "--json"
    assert_path_exists testpath/"project/erden.config.json"
  end
end
