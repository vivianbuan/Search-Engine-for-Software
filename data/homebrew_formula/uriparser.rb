class Uriparser < Formula
  desc "URI parsing library (strictly RFC 3986 compliant)"
  homepage "https://uriparser.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/uriparser/Sources/0.8.4/uriparser-0.8.4.tar.bz2"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/uriparser/uriparser_0.8.4.orig.tar.bz2"
  sha256 "ce7ccda4136974889231e8426a785e7578e66a6283009cfd13f1b24a5e657b23"

  bottle do
    cellar :any
    sha256 "34578f3621c2c8374eacf261e5724b0a3a0a799ebdd9a3b6f2326008761c6e57" => :high_sierra
    sha256 "d1bea100c4dfd9c34ed7c39b7e5c27f2a24453da48fc6b45f37a2e23e7c13eb5" => :sierra
    sha256 "9e4e1ad413aa5ffb4f0e52666df1c6f60551f085969a4e48583d4745d8a85fe6" => :el_capitan
    sha256 "22c5ea8ff69d218577f29684e1b73d81c6d37850639e14e2da497f40ceb29cee" => :yosemite
    sha256 "a09c4d7a93bf0e6f7e67b9c0a30d881f4eda1471acaf1e80c74e4b8f145332bc" => :mavericks
  end

  head do
    url "https://git.code.sf.net/p/uriparser/git.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "cpptest"

  conflicts_with "libkml", :because => "both install `liburiparser.dylib`"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-doc"
    system "make", "check"
    system "make", "install"
  end

  test do
    expected = <<~EOS
      uri:          https://brew.sh
      scheme:       https
      hostText:     brew.sh
      absolutePath: false
    EOS
    assert_equal expected, shell_output("#{bin}/uriparse https://brew.sh").chomp
  end
end
