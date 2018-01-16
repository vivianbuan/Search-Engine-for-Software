class Lightning < Formula
  desc "Generates assembly language code at run-time"
  homepage "https://www.gnu.org/software/lightning/"
  url "https://ftp.gnu.org/gnu/lightning/lightning-2.1.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/lightning/lightning-2.1.2.tar.gz"
  sha256 "9b289ed1c977602f9282da507db2e980dcfb5207ee8bd2501536a6852a157a69"

  bottle do
    cellar :any
    sha256 "ed3fb8e5552f78ef17fa4a5eab54a69068113c28f50723e2a9d9fa68ca9a554d" => :high_sierra
    sha256 "b3898ab467ddc57c03f72615e95fedadf4bbf249ba76ed9de8cc410efe58b114" => :sierra
    sha256 "ddea1c93ea261eb8f49f998deb8769b8b67d44ec955e6dbbe8509d90f5ae9b6e" => :el_capitan
  end

  depends_on "binutils" => [:build, :optional]

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]
    args << "--disable-disassembler" if build.without? "binutils"

    system "./configure", *args
    system "make", "check", "-j1"
    system "make", "install"
  end

  test do
    # from https://www.gnu.org/software/lightning/manual/lightning.html#incr
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <lightning.h>
      static jit_state_t *_jit;
      typedef int (*pifi)(int);
      int main(int argc, char *argv[]) {
        jit_node_t  *in;
        pifi incr;
        init_jit(argv[0]);
        _jit = jit_new_state();
        jit_prolog();
        in = jit_arg();
        jit_getarg(JIT_R0, in);
        jit_addi(JIT_R0, JIT_R0, 1);
        jit_retr(JIT_R0);
        incr = jit_emit();
        jit_clear_state();
        printf("%d + 1 = %d\\n", 5, incr(5));
        jit_destroy_state();
        finish_jit();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-llightning", "-o", "test"
    system "./test"
  end
end
