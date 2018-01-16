class Btparse < Formula
  desc "BibTeX utility libraries"
  homepage "https://www.gerg.ca/software/btOOL/"
  url "https://www.gerg.ca/software/btOOL/btparse-0.34.tar.gz"
  sha256 "e8e2b6ae5de85d1c6f0dc52e8210aec51faebeee6a6ddc9bd975b110cec62698"

  bottle do
    cellar :any
    sha256 "217d4a3998eb3848424a13783333a0440fa78f77943bfe4d1a4b06d5d406b4f5" => :high_sierra
    sha256 "02d9860c4b80590a96b5053cc9b6bfc7646fd204cef602c766665a53382ed116" => :sierra
    sha256 "52b3216a39c5eab22adf83c51843c18789e680bf9bca531a29c2e76c01d00371" => :el_capitan
    sha256 "a8488a0a2601b386d3f53d736d776d7a119d2910841959354cff91b9dec9d59f" => :yosemite
    sha256 "987a65ea6cbd04b6cb70d3f9f64791a1a69d5c69d446c6c712f463957435d0fb" => :mavericks
    sha256 "5ace9431c847dbe4a4d3f04045069eb51a036e9b5a2dce65ccdba7baf165540f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{mxcl09,
        title={{H}omebrew},
        author={{H}owell, {M}ax},
        journal={GitHub},
        volume={1},
        page={42},
        year={2009}
      }
    EOS

    system "#{bin}/bibparse", "-check", "test.bib"
  end
end
