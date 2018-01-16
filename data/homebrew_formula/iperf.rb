class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://iperf.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/iperf/iperf-2.0.5.tar.gz"
  sha256 "636b4eff0431cea80667ea85a67ce4c68698760a9837e1e9d13096d20362265b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9514790acbb2b5821b9773e5a719178eb4d11db158deb1857a68d72e0b9eb6ae" => :high_sierra
    sha256 "441219fd5a227aa8df41c61067d9ae20bb268c48bbdcdad5bce8deb5f32a45fe" => :sierra
    sha256 "4fabcfbc462ea67189847e6faba598a5952bd155e292696cfd39f4d709f926a2" => :el_capitan
    sha256 "37e46ed0ee35a3f0957d847ce4afc871c352108279f8c001c7879282a8706495" => :yosemite
    sha256 "67d2c2cef38fc34704f379a0dcf7d32d0b1bd5d30cd44f0533a6bd55f275bb8a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Otherwise this definition confuses system headers on 10.13
    # https://github.com/Homebrew/homebrew-core/issues/14418#issuecomment-324082915
    if MacOS.version >= :high_sierra
      inreplace "config.h", "#define bool int", ""
    end

    system "make", "install"
  end

  test do
    begin
      server = IO.popen("#{bin}/iperf --server")
      sleep 1
      assert_match "Bandwidth", pipe_output("#{bin}/iperf --client 127.0.0.1 --time 1")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
