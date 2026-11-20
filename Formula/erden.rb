# Written by release/write-package-manifests.mjs in erden-sh/erden from release/pins/0.2.0.json, and updated
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
      url "https://github.com/erden-sh/erden/releases/download/v0.2.0/erden-0.2.0-darwin-arm64.tar.xz"
      sha256 "21da57c9c4f06f433e33f8da807af7d2309b3e06b60b87a98082105c06001f0b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/erden-sh/erden/releases/download/v0.2.0/erden-0.2.0-linux-arm64.tar.xz"
      sha256 "556ac7dfac1bcee71aef867523e92029252f150794554be909d8cf5a4797b01b"
    end
    on_intel do
      url "https://github.com/erden-sh/erden/releases/download/v0.2.0/erden-0.2.0-linux-x64.tar.xz"
      sha256 "4962876ccada2935736f8e443bf590bb3217ba1439d0d2eaaee4300737fe2a42"
    end
  end

  depends_on arch: :arm64 if OS.mac?

  # The engines check their own SHA-256 before every run, and bin/erden carries the CLI inside its Node.js, so nothing
  # in the archive may be stripped or rewritten.
  skip_clean "libexec"

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/erden", libexec/"bin/den"
    # `erden completions` exists in every single-executable archive (no lib/dist) and in the others that ship it.
    if !(libexec/"lib/dist").exist? || (libexec/"lib/dist/completions.js").exist?
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
