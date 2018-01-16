class Sqtop < Formula
  desc "Display information about active connections for a Squid proxy"
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/v2015-02-08.tar.gz"
  version "2015-02-08"
  sha256 "eae4c8bc16dbfe70c776d990ecf14328acab0ed736f0bf3bd1647a3ac2f5e8bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe9a704fdf7f24dadba6b4f7cc20f8f07d93c19450701e01b408ea2f7574ec63" => :high_sierra
    sha256 "30f51d2886adf914eef22af21dfac92f544c59c88b6e7961972eb6702e48d0c0" => :sierra
    sha256 "6d838378cae0971561da60dff1e887bf03b60d1a0ff198a5d468654ef790d9e9" => :el_capitan
    sha256 "29291fedaa06b7b680e44e1b82f643f7ddffc67435312b7c2f3654df0728cb8b" => :yosemite
    sha256 "f1ab5347b698d2e1221a5111fec52022159afc898e5ad7a5318becb23cd35543" => :mavericks
    sha256 "39b62e9a679009e6dc0106a6e63d229b6c310d222966a0f69b90ec388926102e" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqtop --help")
  end
end
