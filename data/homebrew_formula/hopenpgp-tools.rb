require "language/haskell"

class HopenpgpTools < Formula
  include Language::Haskell::Cabal

  desc "Command-line tools for OpenPGP-related operations"
  homepage "https://hackage.haskell.org/package/hopenpgp-tools"
  url "https://hackage.haskell.org/package/hopenpgp-tools/hopenpgp-tools-0.19.5.tar.gz"
  sha256 "e0630a90c0565923b4244eb1df5ba034bcc8a7d092854d197cf47c783bd566f9"
  head "https://anonscm.debian.org/git/users/clint/hopenpgp-tools.git"

  bottle do
    sha256 "4a6735e79e482ba28deaf8b579029761bfd332e5bc3656dd3391eb8c546f96d3" => :high_sierra
    sha256 "1ee1f29b5af38aaff4ffc5288bb7a23d78be4bf560d7f6456b915c8218ad6b2a" => :sierra
    sha256 "2fd337bf48fce294194500b584ffcb62fdf564661bb176a2508588a2adbba965" => :el_capitan
  end

  depends_on "ghc@8.0" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build
  depends_on "nettle"

  resource "homebrew-key.gpg" do
    url "https://gist.githubusercontent.com/zmwangx/be307671d11cd78985bd3a96182f15ea/raw/c7e803814efc4ca96cc9a56632aa542ea4ccf5b3/homebrew-key.gpg"
    sha256 "994744ca074a3662cff1d414e4b8fb3985d82f10cafcaadf1f8342f71f36b233"
  end

  def install
    # Reported 7 Oct 2017 to clint AT debian DOT org
    # RE: happy, see https://github.com/simonmar/happy/issues/94
    # RE: graphviz, see https://github.com/haskell-infra/hackage-trustees/issues/114
    (buildpath/"cabal.config").write <<~EOS
      constraints: happy<1.19.6, graphviz >= 2999.17.0.0
    EOS

    install_cabal_package :using => ["alex", "happy"]
  end

  test do
    resource("homebrew-key.gpg").stage do
      linter_output = shell_output("#{bin}/hokey lint <homebrew-key.gpg 2>/dev/null")
      assert_match "Homebrew <security@brew.sh>", linter_output
    end
  end
end
