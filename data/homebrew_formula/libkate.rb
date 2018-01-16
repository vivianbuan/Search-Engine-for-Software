class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://code.google.com/archive/p/libkate/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/libkate-0.4.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libk/libkate/libkate_0.4.1.orig.tar.gz"
  sha256 "c40e81d5866c3d4bf744e76ce0068d8f388f0e25f7e258ce0c8e76d7adc87b68"
  revision 1

  bottle do
    cellar :any
    rebuild 3
    sha256 "65f687ae05918aa2f2fb4e27f384d6645a0f64231e8dc9343c8435347895d792" => :high_sierra
    sha256 "e7b6c1288455b12044889d768b4593a7a08beac5c4c2534f24565adb58f4a9b5" => :sierra
    sha256 "244a27eb03227b1455bea4ffd9f8a73ccd660389c44e9719d62bba1a4247bdf6" => :el_capitan
    sha256 "473e0de088ba513006bb5212fd9ca21390d848c9cd5e33a7951ee3cba24220ac" => :yosemite
  end

  option "with-docs", "Build documentation"
  option "with-examples", "Build example streams"

  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "oggz" if build.with? "examples"
  depends_on "libpng"
  depends_on "libogg"
  depends_on "wxmac" => :optional

  fails_with :gcc do
    build 5666
    cause "Segfault during compilation"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"katedec", "-V"
  end
end
