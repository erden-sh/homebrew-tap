# Written by release/write-package-manifests.mjs in erden-sh/erden from release/pins/0.2.2.json, and updated
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
      url "https://github.com/erden-sh/erden/releases/download/v0.2.2/erden-0.2.2-darwin-arm64.tar.xz"
      sha256 "3095c0e7b2e84cfa11eca751a9cb1ac296851231ddc6172e35dca40cada3f853"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/erden-sh/erden/releases/download/v0.2.2/erden-0.2.2-linux-arm64.tar.xz"
      sha256 "cd3861f36a712b7d4e9b0f19e55a3aa958e3d40954296b777612f4c2528921e6"
    end
    on_intel do
      url "https://github.com/erden-sh/erden/releases/download/v0.2.2/erden-0.2.2-linux-x64.tar.xz"
      sha256 "dc231ce1d4184bff45dec6b9ae6e9c7ac48067ca5e8e0f58e7ed4819c226d202"
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
