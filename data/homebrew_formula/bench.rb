require "language/haskell"

class Bench < Formula
  include Language::Haskell::Cabal

  desc "Command-line benchmark tool"
  homepage "https://github.com/Gabriel439/bench"
  url "https://hackage.haskell.org/package/bench-1.0.7/bench-1.0.7.tar.gz"
  sha256 "4eb525e06c3ac6acc0a81fb3c1c4558f74bc9ce1d50806a651e9d9d2a3a6c9d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8aa288f6da7bb22733d5addd2fc47294658941cddee1111c77d88b1f27bc487" => :high_sierra
    sha256 "3a8f112df18b6dde7376414ee39bcfa8cbbead5ca8b73c64813a2e9e52cd3e6a" => :sierra
    sha256 "6e1cd403bd49ac54b3b81247d05091e600b723162262eac2d7debecf0abc2404" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    install_cabal_package
  end

  test do
    assert_match /time\s+[0-9.]+/, shell_output("#{bin}/bench pwd")
  end
end
