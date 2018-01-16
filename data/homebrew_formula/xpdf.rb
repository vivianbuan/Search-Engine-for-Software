class Xpdf < Formula
  desc "PDF viewer"
  homepage "http://www.foolabs.com/xpdf/"
  url "https://www.xpdfreader.com/dl/old/xpdf-3.04.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/xpdf/xpdf-3.04.tar.gz/3bc86c69c8ff444db52461270bef3f44/xpdf-3.04.tar.gz"
  mirror "https://fossies.org/linux/misc/legacy/xpdf-3.04.tar.gz"
  sha256 "11390c74733abcb262aaca4db68710f13ffffd42bfe2a0861a5dfc912b2977e5"
  revision 1

  bottle do
    sha256 "96aa36fb15857fb59208e511d02e4e7eee88b3f1b4d4bad59b6c0ec3e7aa5346" => :high_sierra
    sha256 "a1abda067ab10b0e3a79ab9a93695ca2ad5fc674fff46a686ff11df47a076119" => :sierra
    sha256 "e99ea80af29dd4dc4b3898ff4fe6dad14e904181b274be785da16103e4ec425f" => :el_capitan
    sha256 "3bd281f7bbc232ec0e353e3a54955383e13897fe563dfcadc4057e625803a6fb" => :yosemite
  end

  depends_on "openmotif"
  depends_on "freetype"
  depends_on :x11

  conflicts_with "pdf2image", "poppler",
    :because => "xpdf, pdf2image, and poppler install conflicting executables"

  def install
    freetype = Formula["freetype"]
    openmotif = Formula["openmotif"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-freetype2-library=#{freetype.opt_lib}",
                          "--with-freetype2-includes=#{freetype.opt_include}/freetype2",
                          "--with-Xm-library=#{openmotif.opt_lib}",
                          "--with-Xm-includes=#{openmotif.opt_include}",
                          "--with-Xpm-library=#{MacOS::X11.lib}",
                          "--with-Xpm-includes=#{MacOS::X11.include}",
                          "--with-Xext-library=#{MacOS::X11.lib}",
                          "--with-Xext-includes=#{MacOS::X11.include}",
                          "--with-Xp-library=#{MacOS::X11.lib}",
                          "--with-Xp-includes=#{MacOS::X11.include}",
                          "--with-Xt-library=#{MacOS::X11.lib}",
                          "--with-Xt-includes=#{MacOS::X11.include}"
    system "make"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end
