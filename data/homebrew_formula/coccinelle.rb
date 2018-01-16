class Coccinelle < Formula
  desc "Program matching and transformation engine for C code"
  homepage "http://coccinelle.lip6.fr/"
  url "http://coccinelle.lip6.fr/distrib/coccinelle-1.0.6.tgz"
  sha256 "8452ed265c209dae99cbb33b67bc7912e72f8bca1e24f33f1a88ba3d7985e909"
  revision 1

  bottle do
    rebuild 1
    sha256 "ee482fedbe053e43b24930b0fd568db3c94f1179b6ce796c6445a75f13dad858" => :high_sierra
    sha256 "00da6a22f987eb816c239e5852a423fdccf8c077143358eb623d4cf933ce0a7d" => :sierra
    sha256 "96f2460057f45cc77e03c1980edff643cdc26a2d2cced838567c798d3ee89748" => :el_capitan
  end

  depends_on "ocaml"
  depends_on "camlp4"
  depends_on "opam" => :build
  depends_on "hevea" => :build

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

    opamroot = buildpath/"opamroot"
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"
    system "./configure", "--disable-dependency-tracking",
                          "--enable-release",
                          "--enable-ocaml",
                          "--enable-opt",
                          "--enable-ocaml",
                          "--with-pdflatex=no",
                          "--prefix=#{prefix}"
    system "opam", "config", "exec", "--", "make"
    system "make", "install"

    pkgshare.install "demos/simple.cocci", "demos/simple.c"
  end

  test do
    system "#{bin}/spatch", "-sp_file", "#{pkgshare}/simple.cocci",
                            "#{pkgshare}/simple.c", "-o", "new_simple.c"
    expected = <<~EOS
      int main(int i) {
        f("ca va", 3);
        f(g("ca va pas"), 3);
      }
    EOS
    assert_equal expected, (testpath/"new_simple.c").read
  end
end
