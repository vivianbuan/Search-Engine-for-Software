class Tcptrack < Formula
  desc "Monitor status of TCP connections on a network interface"
  homepage "https://linux.die.net/man/1/tcptrack"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/t/tcptrack/tcptrack_1.4.2.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/t/tcptrack/tcptrack_1.4.2.orig.tar.gz"
  sha256 "6607b1e1c778c49d3e8795e119065cf66eb2db28b3255dbc56b1612527107049"

  bottle do
    cellar :any_skip_relocation
    sha256 "7abe4e7c84ff5d39f3a389056f4412d23dfb711062e1a9abdd1194ba5ff2ad67" => :high_sierra
    sha256 "f84deb6bc918678e365db7810b3dd3ff2b3dbc0af25bce58f81fe22256951459" => :sierra
    sha256 "93022ecf618c41d508175e15bb6cdbc6d24206cebe9e6f77524b8ab066134f2f" => :el_capitan
    sha256 "23ee40e3789155774146fee0e1b99cba1792bef8ddfe0aa9d98864a32545445e" => :yosemite
    sha256 "f1d33c99082cbcff0030a40c164f680a6e6e995b9b92c6b414c1e2d4d25d67f6" => :mavericks
  end

  def install
    ENV.libstdcxx

    # Fix IPv6 on MacOS. The patch was sent by email to the maintainer
    # (tcptrack2@s.rhythm.cx) on 2010-11-24 for inclusion.
    # Still not fixed in 1.4.2 - @adamv
    inreplace "src/IPv6Address.cc", "s6_addr16", "__u6_addr.__u6_addr16"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Run tcptrack as root or via sudo in order for the program
    to obtain permissions on the network interface.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tcptrack -v")
  end
end
