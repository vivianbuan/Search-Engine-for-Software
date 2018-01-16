class Sshtrix < Formula
  desc "SSH login cracker"
  homepage "http://www.nullsecurity.net/tools/cracker.html"
  url "https://github.com/nullsecuritynet/tools/raw/master/cracker/sshtrix/release/sshtrix-0.0.2.tar.gz"
  sha256 "dc90a8b2fbb62689d1b59333413b56a370a0715c38bf0792f517ed6f9763f5df"

  bottle do
    cellar :any
    sha256 "8755bd6e5e55baf13212c26b752aa7477e19ca7925b7951f08b7bd7609bbea94" => :high_sierra
    sha256 "406825d6203b5d5c2dc6652617a37373d99d15be4c47aa7474414eb2c226c191" => :sierra
    sha256 "7e1510ecc837aaf0d2ec15af981fdd101bdd71812c0b298645b31a6a97e80b4a" => :el_capitan
    sha256 "2fd9c4a2d64419d0e3599b17ea244911420276ecd8c0f4ded909730413121ec0" => :yosemite
    sha256 "91023afd20f82c8d93497c460344fb00a718343fa52e1ad48299b876c8699be1" => :mavericks
    sha256 "c4c325be267741bdc3ba858f21834b8666f734463c28b28e2ad652bbee154b95" => :mountain_lion
  end

  depends_on "libssh"

  def install
    bin.mkpath
    system "make", "sshtrix", "CC=#{ENV.cc}"
    system "make", "DISTDIR=#{prefix}", "install"
  end

  test do
    system "#{bin}/sshtrix", "-V"
    system "#{bin}/sshtrix", "-O"
  end
end
