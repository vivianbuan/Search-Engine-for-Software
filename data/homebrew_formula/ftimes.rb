class Ftimes < Formula
  desc "System baselining and evidence collection tool"
  homepage "https://ftimes.sourceforge.io/FTimes/index.shtml"
  url "https://downloads.sourceforge.net/project/ftimes/ftimes/3.11.0/ftimes-3.11.0.tgz"
  sha256 "70178e80c4ea7a8ce65404dd85a4bf5958a78f6a60c48f1fd06f78741c200f64"
  revision 1

  bottle do
    sha256 "11d86838a177c545f13e0e979a370c561ffab8a1c677259d28203501f0243864" => :high_sierra
    sha256 "cbca23c29665bef95b9245e329cfafbb33f5dcc7fa1b60c1ff9e84498bafff91" => :sierra
    sha256 "7c782808f555c9f8afa2bca44c064f9898bcf3a66a14e7b859124f0afc85c97e" => :el_capitan
    sha256 "0cc52b1c4396b5adca1a3adc4a2942f0beef27392f23cb6533db79c54a3657ca" => :yosemite
    sha256 "214b8092f738542005f77d146cc6b85ee69f2f100469dc6e2b78b5f2f0b5c132" => :mavericks
    sha256 "fbe09e2f091d3b828a2f3802674203f4f72b6e0136fe6f442bf8313234be5373" => :mountain_lion
  end

  depends_on "pcre"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-pcre=#{Formula["pcre"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-server-prefix=#{var}/ftimes"

    inreplace "doc/ftimes/Makefile" do |s|
      s.change_make_var! "INSTALL_PREFIX", man1
    end

    system "make", "install"
  end

  test do
    assert_match /ftimes #{version}/, shell_output("#{bin}/ftimes --version")
  end
end
