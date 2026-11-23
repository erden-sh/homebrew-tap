# Written by release/write-package-manifests.mjs in erden-sh/erden from release/pins/0.2.1.json, and updated
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
      url "https://github.com/erden-sh/erden/releases/download/v0.2.1/erden-0.2.1-darwin-arm64.tar.xz"
      sha256 "417fb56087d16ec6d5761555daa03338085bae3fd8cf5cb89dfe13e5f9a76e2d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/erden-sh/erden/releases/download/v0.2.1/erden-0.2.1-linux-arm64.tar.xz"
      sha256 "6134dff5487e60997de208cdbc94e4723c5c713b3afa45bcd35188153689d2ee"
    end
    on_intel do
      url "https://github.com/erden-sh/erden/releases/download/v0.2.1/erden-0.2.1-linux-x64.tar.xz"
      sha256 "9b9eb15dc414f4a4800d7d9998ab31d9d789c96db5b48fb780738031855aa136"
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
