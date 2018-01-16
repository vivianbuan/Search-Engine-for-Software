class I3 < Formula
  desc "Tiling window manager"
  homepage "https://i3wm.org/"
  url "https://i3wm.org/downloads/i3-4.14.1.tar.bz2"
  sha256 "d0063ac561f3aa8d7e31e137356815bad781bd6ad774030362c89abe96ab5fb1"
  head "https://github.com/i3/i3.git"

  bottle do
    sha256 "e0158b3f76f09deb6254022af4cf797b8984ac002e9f00444f54ddb3f00a78fd" => :high_sierra
    sha256 "cae76ee532cde865d6965786790768757d2d8156bcd8c59a7e7f4ae1ce4575a8" => :sierra
    sha256 "fb731e5623251134919b0b823e40300df8eeeef609e9fb4c04b79ed5725f00ba" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "xmlto" => :build
  depends_on "cairo" => ["with-x11"]
  depends_on "gettext"
  depends_on "libev"
  depends_on "pango"
  depends_on "pcre"
  depends_on "startup-notification"
  depends_on "yajl"
  depends_on :x11
  depends_on "libxkbcommon"

  resource "xcb-util-xrm" do
    url "https://github.com/Airblader/xcb-util-xrm/releases/download/v1.2/xcb-util-xrm-1.2.tar.bz2"
    sha256 "f75ec8d909cccda2f4d1460f9639338988a0946188b9d2109316c4509e82786d"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    resource("xcb-util-xrm").stage do
      system "./configure", "--prefix=#{libexec}/xcb-util-xrm"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/xcb-util-xrm/lib/pkgconfig"

    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"

    cd "x86_64-apple-darwin#{`uname -r`.chomp}" do
      system "make", "install", "LDFLAGS=-liconv"
    end
  end

  test do
    result = shell_output("#{bin}/i3 -v")
    result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
    assert_match version.to_s, result
  end
end
