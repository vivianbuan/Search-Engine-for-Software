class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.4.4.tar.gz"
  sha256 "2379b8b3e9498d426a0bc03b90d74170a80f98f167f89c126d53dcc66bc5f60b"

  bottle do
    sha256 "035b453e0a13dadfb3c23b55b57c923f28f4940aef05dd93cdb2f591fe416929" => :high_sierra
    sha256 "68d0733f5e1b07ebb3e63f8a7f72cfccbb196477a460d545769d21eab6568ff4" => :sierra
    sha256 "bbfd86b19188591ba77f89ef44dd4bd1fcbcc60d2bc709a3b1dfc5e538f17086" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
