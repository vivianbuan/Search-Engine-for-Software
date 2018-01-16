class Compface < Formula
  desc "Convert to and from the X-Face format"
  homepage "http://freecode.com/projects/compface"
  url "https://mirrorservice.org/sites/ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  mirror "https://ftp.heanet.ie/mirrors/ftp.xemacs.org/aux/compface-1.5.2.tar.gz"
  mirror "http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz"
  sha256 "a6998245f530217b800f33e01656be8d1f0445632295afa100e5c1611e4f6825"

  bottle do
    cellar :any_skip_relocation
    sha256 "15f3ed9a165fa2f4966fde4de5b8b1c62d583425e0c3d9961b26348f6355bfcc" => :high_sierra
    sha256 "092d90367b0fa75ff8a1be3982cda127226fb9805c681170f66fe27c148c8d1b" => :sierra
    sha256 "50200eb6f7cb61be39420d2e127eb4e2af9391a514f7cfbd26fa9203ca137d21" => :el_capitan
    sha256 "4f7a202ead9c7b6ba1498be71c937500d64cad15ae451ec37c54a8fba70816a0" => :yosemite
    sha256 "3208feb3c0055906ee163662c0d5b5cbe561222128a0979f6e159110973ee3fa" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"
  end

  test do
    system bin/"uncompface"
  end
end
