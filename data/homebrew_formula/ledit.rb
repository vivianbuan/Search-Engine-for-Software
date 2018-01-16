class Ledit < Formula
  desc "Line editor for interactive commands"
  homepage "http://pauillac.inria.fr/~ddr/ledit/"
  url "http://pauillac.inria.fr/~ddr/ledit/distrib/src/ledit-2.03.tgz"
  sha256 "ce08a8568c964009ccb0cbba45ae78b9a96c823f42a4fd61431a5b0c2c7a19ce"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "63545ec7be9fe95ab6b8aa4924149430015c8887b30a6399cdeadfa2787acb0e" => :high_sierra
    sha256 "4a26786028c08c41b493f9e05dcd8e1cad1be78607a1dc243f23162632bbaa2a" => :sierra
    sha256 "4a3c0a8da1f765c3490c2fceac34ca093927c94d5ae03e5701654b83fa16d4fc" => :el_capitan
    sha256 "9d16c9b4d75e5d0d1caa9823f282899a0034bada1a46d7809a9dd37d5759563a" => :yosemite
  end

  depends_on "ocaml"
  depends_on "camlp5"

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

    # like camlp5, this build fails if the jobs are parallelized
    ENV.deparallelize
    args = %W[BINDIR=#{bin} LIBDIR=#{lib} MANDIR=#{man}]
    system "make", *args
    system "make", "install", *args
  end

  test do
    history = testpath/"history"
    pipe_output("#{bin}/ledit -x -h #{history} bash", "exit\n", 0)
    assert history.exist?
    assert_equal "exit\n", history.read
  end
end
