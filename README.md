# Erden Homebrew tap

The Homebrew formula for [Erden](https://erden.sh)'s command line tool, `erden` (also available as `den`), which
checks, packs and publishes ontology projects. The tool's source is in [erden-sh/erden](https://github.com/erden-sh/erden).

```bash
brew install erden-sh/tap/erden
```

The formula installs the release archive for macOS on Apple silicon or Linux x64 and arm64. Each archive carries the
Node.js runtime and both engines the tool runs on, so the formula has no dependencies. It installs shell completions
for bash, zsh and fish from releases that have `erden completions`.

`Formula/erden.rb` is written from the release's pinned archive digests by `release/write-package-manifests.mjs` in
erden-sh/erden, and its release workflow pushes it here after each release installs and runs on every platform. Please
don't edit it by hand: open an issue in [erden-sh/erden](https://github.com/erden-sh/erden/issues) instead.

## License

Apache License 2.0 (see [LICENSE](LICENSE)); the copyright holder is Ingenio Ventures Inc. "Erden" is a trademark of
Ingenio Ventures Inc.
