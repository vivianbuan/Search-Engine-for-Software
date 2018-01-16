class XmlToolingC < Formula
  desc "Provides a higher level interface to XML processing"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/XMLTooling-C"
  url "https://shibboleth.net/downloads/c++-opensaml/2.6.0/xmltooling-1.6.0.tar.gz"
  sha256 "25814c49e27cdc97e17d42ca503e325f7e474ca3558a5a6b476e57a8a3c1a20e"
  revision 1

  bottle do
    cellar :any
    sha256 "f1f80112f7f334c2644e1eb2575ff043a7a56f6aec7211aeba740c92132ed4f3" => :high_sierra
    sha256 "b7905a3551596c9e7ab15d83e651a1ad021fb94bafcf420a1f501a82e0092b1b" => :sierra
    sha256 "2312c6ffc7a3ed3bebdd660b9ca1ad51c96905d2f59381a5c22bd0494af5cca1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "log4shib"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "boost"
  depends_on "openssl"
  depends_on "curl" => "with-openssl"

  needs :cxx11

  def install
    ENV.O2 # Os breaks the build
    ENV.cxx11

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
