class Cdpr < Formula
  desc "Cisco Discovery Protocol Reporter"
  homepage "http://www.monkeymental.com/"
  url "https://downloads.sourceforge.net/project/cdpr/cdpr/2.4/cdpr-2.4.tgz"
  sha256 "32d3b58d8be7e2f78834469bd5f48546450ccc2a86d513177311cce994dfbec5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce836a4189c94a1441cb417f36699fca01e3cf30b69bcc5a3ec8307c51d0f66e" => :high_sierra
    sha256 "c6603372329fd2dc0c60266b3f3eb6c9f7cc5c0ce7f351b05977ab39a18cde7c" => :sierra
    sha256 "0bdc868c9b11510e2d9e6551dee970c20406215153906d8bc42790d8510ac429" => :el_capitan
    sha256 "3f0fbd6fe9862b367f64354ad6ce3b2deacd35ae627f8d73d5095739325be378" => :yosemite
    sha256 "d23bf22f119337fdb04c7a016046ceb6c724d63015f19620d55c3e4883827f21" => :mavericks
  end

  def install
    # Makefile hardcodes gcc and other atrocities
    system ENV.cc, ENV.cflags, "cdpr.c", "cdprs.c", "conffile.c", ENV.ldflags, "-lpcap", "-o", "cdpr"
    bin.install "cdpr"
  end

  def caveats
    "run cdpr sudo'd in order to avoid the error: 'No interfaces found! Make sure pcap is installed.'"
  end
end
