class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://osdn.net/projects/rctools/"
  url "https://ja.osdn.net/frs/redir.php?f=%2Frctools%2F51941%2Flibrcsc-4.1.0.tar.gz"
  mirror "http://dl.osdn.jp/rctools/51941/librcsc-4.1.0.tar.gz"
  sha256 "1e8f66927b03fb921c5a2a8c763fb7297a4349c81d1411c450b180178b46f481"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4bd96acb6e78620e25b3b33e745e7770ea812cde22a3d756ac978c778d3b993c" => :high_sierra
    sha256 "c8b9dc2887f771f07b33bb70cec9ab62b4cee067f8b3a2d7ae57296428881031" => :sierra
    sha256 "c2093c232c857c15bea5dd6c1c6df14aa4b00ed0c6eb3ab7e4d0d3f8c72b54c6" => :el_capitan
    sha256 "c339890cbed4a1ca1b0a14d4375ece92ccee44a1f29023e1f633e9a9e0d6b6d5" => :yosemite
    sha256 "db8f74fadedc34da92c2109c1bbb90971c494e104c6041f1c8429def7f14dbc9" => :mavericks
    sha256 "ac8ae186e76e68384bc66b331757f877c0b02c6472f88b1e846b3b1065dd6ffa" => :mountain_lion
  end

  depends_on "boost"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc_rcg"
    system "./test"
  end
end
