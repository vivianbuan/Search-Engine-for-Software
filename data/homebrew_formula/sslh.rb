class Sslh < Formula
  desc "Forward connections based on first data packet sent by client"
  homepage "https://www.rutschle.net/tech/sslh.shtml"
  url "https://www.rutschle.net/tech/sslh/sslh-v1.18.tar.gz"
  sha256 "1601a5b377dcafc6b47d2fbb8d4d25cceb83053a4adcc5874d501a2d5a7745ad"
  revision 1
  head "https://github.com/yrutschle/sslh.git"

  bottle do
    cellar :any
    sha256 "fe98f0cd7455170be02b755a9501ac54e8e95716344f7b01052dd8651e24bb2f" => :high_sierra
    sha256 "db949cf82e5db94862e6ac64f952a4face1bdf04e5aa5058f858deba64e5c826" => :sierra
    sha256 "5803ea7f103f4f36c00842a2f7aee0e02bd87a077e713040113ffa5fa2f94fdc" => :el_capitan
  end

  depends_on "libconfig"

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/sslh -V")
  end
end
