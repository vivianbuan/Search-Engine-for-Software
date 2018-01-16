class Rmtrash < Formula
  desc "Move files to macOS's Trash"
  homepage "http://www.nightproductions.net/cli.htm"
  url "http://www.nightproductions.net/downloads/rmtrash_source.tar.gz"
  version "0.3.3"
  sha256 "9b30561454529e5923ffb62327d3fe009d23495263efc958534ac6b637e361d6"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1acafe5b7c1d492c6f3aa685c37a56c51972fdd62b6653ee6efb2f2f0b9a7715" => :high_sierra
    sha256 "e9770d2d1fef053ba9743548537fb70ca491755c10c0a6b6d106e919d86c4b54" => :sierra
    sha256 "a8b6815f555377a91e800085db9680cc9234b27a4b114ea13e6664a2b1b663d3" => :el_capitan
    sha256 "adab3849ec805b7c2679e9b278e4d101249193dbd7210f078224e69fc3bb2f1f" => :yosemite
    sha256 "102f54f713574d7009e3b4fd33738b6b631608a0c38f6ad0945ca1af5a8d6ef5" => :mavericks
  end

  def install
    # don't install as root
    inreplace "Makefile", "-o root -g wheel", ""
    # install manpages under share/man/
    inreplace "Makefile", "${DESTDIR}/man", "${DESTDIR}/share/man"

    bin.mkpath
    man1.mkpath

    system "make", "CC=#{ENV.cc}", "LDFLAGS=-framework Foundation -prebind"
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    system "#{bin}/rmtrash", "-h"
  end
end
