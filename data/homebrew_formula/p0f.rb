class P0f < Formula
  desc "Versatile passive OS fingerprinting, masquerade detection tool"
  homepage "http://lcamtuf.coredump.cx/p0f3/"
  url "http://lcamtuf.coredump.cx/p0f3/releases/p0f-3.09b.tgz"
  sha256 "543b68638e739be5c3e818c3958c3b124ac0ccb8be62ba274b4241dbdec00e7f"

  bottle do
    rebuild 1
    sha256 "ccd5b804de7e6fd430540283d6064d4647e1224dd2663f21e309a4077b1c30b9" => :high_sierra
    sha256 "bd25792c98fd8c88599ab373ed8b9265fe4b69c47b6b3ebc84911750f48f190d" => :sierra
    sha256 "37aea629cea6430b8516ea80eaaf687844a2a1656eebe7744ba6f3746381ce48" => :el_capitan
  end

  def install
    inreplace "config.h", "p0f.fp", "#{etc}/p0f/p0f.fp"
    system "./build.sh"
    sbin.install "p0f"
    (etc/"p0f").install "p0f.fp"
  end

  test do
    system "#{sbin}/p0f", "-r", test_fixtures("test.pcap")
  end
end
