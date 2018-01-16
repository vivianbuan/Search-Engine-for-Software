class Cdk < Formula
  desc "Curses development kit provides predefined curses widget for apps"
  homepage "https://invisible-island.net/cdk/"
  url "https://invisible-mirror.net/archives/cdk/cdk-5.0-20161210.tgz"
  version "5.0.20161210"
  sha256 "9e7558cb8850ca5c7ab4cc38e0612b0e8c4aad680d2a2511f31d62f239e35fad"

  bottle do
    cellar :any_skip_relocation
    sha256 "58947bcaa78cd6bbb03d2797c9069e4f5cda3df8fd972d31037a44d2e820b8cb" => :high_sierra
    sha256 "9240fdefe719921575f0328654b1038bfcb417ae335b44c3d9325f8eaa7af83f" => :sierra
    sha256 "8979461bd3a811edc8f34cff0b042cba1dafe447a27941452932a34adc103760" => :el_capitan
    sha256 "a8e99ff4229beec14a5c9bc528619057ac09f946db75251ce0b281094cc5d3c1" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install"
  end

  test do
    assert_match lib.to_s, shell_output("#{bin}/cdk5-config --libdir")
  end
end
