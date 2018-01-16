class Sc68 < Formula
  desc "Play music originally designed for Atari ST and Amiga computers"
  homepage "http://sc68.atari.org/project.html"
  url "https://downloads.sourceforge.net/project/sc68/sc68/2.2.1/sc68-2.2.1.tar.gz"
  sha256 "d7371f0f406dc925debf50f64df1f0700e1d29a8502bb170883fc41cc733265f"

  bottle do
    sha256 "b3e4809754847ca52468463ed60293032efeecf42f24acd3026bb03d369a91d9" => :high_sierra
    sha256 "0b5a0931d6f72700ca691436ed69d467cc043aea9b3454d628050886ccd12141" => :sierra
    sha256 "d5ac5c810d4f3505230f2cdb9bc3f9f8c14394e1663f30f8d601fe4a559f99c8" => :el_capitan
    sha256 "b6b3fb845e14cd2c35212911b261bb4a15f38c528522789fd5905e762b7d0bfc" => :yosemite
    sha256 "8834ebed226bb20898b91be054fbd54491f524ea780c6559eba1c97166bf7e7d" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    # SC68 ships with a sample module; test attempts to print its metadata
    system "#{bin}/info68", "#{pkgshare}/Sample/About-Intro.sc68", "-C", ": ", "-N", "-L"
  end
end
