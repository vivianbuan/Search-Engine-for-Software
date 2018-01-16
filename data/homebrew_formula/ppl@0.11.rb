class PplAT011 < Formula
  desc "Numerical abstractions for analysis, verification"
  homepage "http://bugseng.com/products/ppl/"
  # Track gcc infrastructure releases.
  url "https://gcc.gnu.org/pub/gcc/infrastructure/ppl-0.11.tar.gz"
  mirror "http://bugseng.com/products/ppl/download/ftp/releases/0.11/ppl-0.11.tar.gz"
  sha256 "3453064ac192e095598576c5b59ecd81a26b268c597c53df05f18921a4f21c77"
  revision 1

  bottle do
    rebuild 1
    sha256 "f3b8f5e6c5fa4ad3479b19ec4a661ec2f73fd8dfb1a18aa45f6d1feea8af64d5" => :high_sierra
    sha256 "28b29ead285c5cab1a31957c685f81fd5d429fdd2d9f1c4209404f5c3dd34ce0" => :sierra
    sha256 "bd04cf76f1bf509a58ecc7f23032e75a943047889094363dab4a957dd8314281" => :el_capitan
    sha256 "1ce289ae5568772a3f3153e2bc74dc29ab2e8f810ecca5c60813df45c66ed81e" => :yosemite
  end

  keg_only :versioned_formula

  depends_on "gmp@4"

  # https://www.cs.unipr.it/mantis/view.php?id=596
  # https://github.com/Homebrew/homebrew/issues/27431
  # Using different patch from upstream bug report to avoid autoreconf.
  patch do
    url "https://gist.githubusercontent.com/manphiz/9507743/raw/45081e12c2f1faf81e8536f365af05173c6dab5c/patch-ppl-flexible-array-clang_v2.patch"
    sha256 "db8ced5366ec4c3efb6fd20d3b4e440de3f8b9ec1d930a33b6a23d006dc25944"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppl_lpsol",
                          "--disable-ppl_lcdd",
                          "--disable-ppl_pips",
                          "--with-gmp-prefix=#{Formula["gmp@4"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    EOS
    gmp = Formula["gmp@4"]
    system ENV.cc, "test.c", "-o", "test",
                   "-lgmp", "-I#{gmp.include}", "-L#{gmp.lib}",
                   "-lppl_c", "-lppl", "-I#{include}", "-L#{lib}"
    system "./test"
  end
end
