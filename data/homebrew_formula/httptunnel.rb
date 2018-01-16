class Httptunnel < Formula
  desc "Tunnels a data stream in HTTP requests"
  homepage "https://github.com/larsbrinkhoff/httptunnel"
  url "https://ftp.gnu.org/gnu/httptunnel/httptunnel-3.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/httptunnel/httptunnel-3.3.tar.gz"
  sha256 "142f82b204876c2aa90f19193c7ff78d90bb4c2cba99dfd4ef625864aed1c556"

  bottle do
    cellar :any_skip_relocation
    sha256 "6012d5967ab7263658ce1da99ee7bbdd051e37243b922b0702f4279ed047c014" => :high_sierra
    sha256 "64b548d12c4e3012cb9d8d9f5171e0fc47e594c13f4d4ae35c5f97be1582b263" => :sierra
    sha256 "b328d4e1f1e2638764d3ac2ed32a4f4e06935e4e9ef83af281936df4ab805aa5" => :el_capitan
    sha256 "54fbed6b247d143f05c50c2202b5ff447f90504553431e7a143f6178893f148c" => :yosemite
    sha256 "dcec84a118e1e7246d29ccc12397b7aa0134e1a2a952aa83af7b4ba6745318ac" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/hts --stdin-stdout --pid-file #{testpath}/pid 8081"
    end
    sleep 2

    begin
      assert_predicate testpath/"pid", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
