class Ps2eps < Formula
  desc "Convert PostScript to EPS files"
  homepage "https://www.tm.uka.de/~bless/ps2eps"
  url "https://www.tm.uka.de/~bless/ps2eps-1.68.tar.gz"
  sha256 "b08f12eed88965d1891261fb70e87c7e3a3f3172ebc31bdb7994a7ce854dd925"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e0d89ac5be6cb6357d84988a1adc26e6667f4e9cdd8047071d0204cbecee58e" => :high_sierra
    sha256 "55396ec4ff00cfc85c4e34f1f7b872834264d8640677cd430c16b10fe67f2fa9" => :sierra
    sha256 "a651d45a267206348a36d213620790b0951e5343070d8613548b80066ec5a584" => :el_capitan
    sha256 "99b3838d2a7135d8794e4f48e428bd8afc0f18db8998f071c74faa449591ad7f" => :yosemite
    sha256 "01fbee92f6a8534a4618bb94b9d21913f203b42f7abe41023c7c2b2f68775880" => :mavericks
    sha256 "4671a8ae732598cbf5c006b7cf6f9924455a8f61dcc660733e14104707974c27" => :mountain_lion
  end

  depends_on "ghostscript"

  def install
    system ENV.cc, "src/C/bbox.c", "-o", "bbox"
    bin.install "bbox"
    (libexec/"bin").install "bin/ps2eps"
    (bin/"ps2eps").write <<~EOS
      #!/bin/sh
      perl -S #{libexec}/bin/ps2eps $*
    EOS
    share.install "doc/man"
    doc.install "doc/pdf", "doc/html"
  end

  test do
    cp test_fixtures("test.ps"), testpath/"test.ps"
    system bin/"ps2eps", testpath/"test.ps"
    assert_predicate testpath/"test.eps", :exist?
  end
end
