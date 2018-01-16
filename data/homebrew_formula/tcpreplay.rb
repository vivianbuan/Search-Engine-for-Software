class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.2.6/tcpreplay-4.2.6.tar.gz"
  sha256 "043756c532dab93e2be33a517ef46b1341f7239278a1045ae670041dd8a4531d"

  bottle do
    cellar :any
    sha256 "9be61ec3aeeac7be8cd51225d5914a7ba7ee8f0c9fbd4393e452f6b9447a53c7" => :high_sierra
    sha256 "569bdb4ac12e4ff62c723b1fdabad4b037c54423a70742306ba852f9bc43e25d" => :sierra
    sha256 "b5ba1668dddf52946866c866bc1ba2ab2983b67d99c69b6c41fabe91e816139a" => :el_capitan
    sha256 "3eaba6e1af68c8af3f7d1d0a15c2563b178368a74a760e3fafa5b3c4774f9129" => :yosemite
  end

  depends_on "libdnet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link"
    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
