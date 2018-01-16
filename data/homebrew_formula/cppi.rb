class Cppi < Formula
  desc "Indent C preprocessor directives to reflect their nesting"
  homepage "https://www.gnu.org/software/cppi/"
  url "https://ftp.gnu.org/gnu/cppi/cppi-1.18.tar.xz"
  mirror "https://ftpmirror.gnu.org/cppi/cppi-1.18.tar.xz"
  sha256 "12a505b98863f6c5cf1f749f9080be3b42b3eac5a35b59630e67bea7241364ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc8253f982b219088603021d510a6e7ee6d692ff5f693da19b32d0431bc9c9b4" => :high_sierra
    sha256 "d4c044247ba8a12f1462089bfa22602547894f0a9081fce21c4800e192a526ae" => :sierra
    sha256 "970e44d2a7a340fe29577f92c4b6dfcbac17f3aef35e6085197b668c4cd9013f" => :el_capitan
    sha256 "f8198f4b6e76d9310d66d20cb0a5b2b6adc70bee83f0bbeaca8b45b6529ccc60" => :yosemite
    sha256 "a37872a422b21892119583f4fe9670ff403d2e40ceb14f50166e2b501938c544" => :mavericks
    sha256 "9924d9e02cf7b197d666ffc8e9a56a5d4e442a5fa8c598872c714c7a2dfb37f3" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    test = <<~EOS
      #ifdef TEST
      #include <homebrew.h>
      #endif
    EOS
    assert_equal <<~EOS, pipe_output("#{bin}/cppi", test, 0)
      #ifdef TEST
      # include <homebrew.h>
      #endif
    EOS
  end
end
