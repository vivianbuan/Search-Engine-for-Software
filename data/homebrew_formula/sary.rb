class Sary < Formula
  desc "Suffix array library"
  homepage "https://sary.sourceforge.io/"
  url "https://sary.sourceforge.io/sary-1.2.0.tar.gz"
  sha256 "d4b16e32c97a253b546922d2926c8600383352f0af0d95e2938b6d846dfc6a11"

  bottle do
    cellar :any
    sha256 "2955ddf7ee2ed864c157fd470afed1a89a3f5124153349e42f51a0b319b8fc1d" => :high_sierra
    sha256 "35da6b40c316be03a8375beb5001ddff5827d8728bea5d5ee5fa86e2ab885089" => :sierra
    sha256 "aedca3dec29eb2b2aea582002e23cd1b92a92bf30e6b46f8241f3c48ac312f00" => :el_capitan
    sha256 "1ef3eadf64fd9bcaeed1f01e7b03504fdcfbbe5bb65fe7e5da5aece9b73055a3" => :yosemite
    sha256 "b41f84ca9dc8bb27eeba82e1d13008f8b56a357ede1ab1987337561347cd6d94" => :mavericks
    sha256 "a1f528db66834372eac1e85513cbbfa8bc1242988bd31a986a9ea0fcec768b37" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      Some text,
      this is the Sary formula, a suffix array library and tools,
      more text.
      more. text.
    EOS

    system "#{bin}/mksary", "test"
    assert_predicate testpath/"test.ary", :exist?

    assert_equal "Some text,\nmore text.\nmore. text.",
      shell_output("#{bin}/sary text test").chomp
  end
end
