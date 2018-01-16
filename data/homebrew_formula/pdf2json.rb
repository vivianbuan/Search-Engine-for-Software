class Pdf2json < Formula
  desc "PDF to JSON and XML converter"
  homepage "https://github.com/flexpaper/pdf2json"
  url "https://github.com/flexpaper/pdf2json/releases/download/v0.69/pdf2json-0.69.tar.gz"
  sha256 "69394ef5d5d5504f7106e8b55e15bf491c48d906d611e6bc2e5952005a85b593"

  bottle do
    sha256 "60d1c24f08283b8040f2e7e9154f7fcccaa415199fb77fefe843eebb74583019" => :high_sierra
    sha256 "586c26331ad9becac719c803c71be519ea3684c28ab80db457e8f61df9485234" => :sierra
    sha256 "92852d5246f34ed87340f347f8645c60e39f7cbd924c2e94cf199f4f9d42ddc6" => :el_capitan
    sha256 "3c10495304bdf5d1c99127219e79d3693bfd8141c861596e791935472c59246c" => :yosemite
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "src/pdf2json"
  end

  test do
    system bin/"pdf2json", test_fixtures("test.pdf"), "test.json"
    assert_predicate testpath/"test.json", :exist?
  end
end
