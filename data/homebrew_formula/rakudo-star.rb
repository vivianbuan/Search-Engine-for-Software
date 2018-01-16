class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "https://rakudo.perl6.org/downloads/star/rakudo-star-2017.10.tar.gz"
  sha256 "d52498b8838f168d654fa669cfc3abc5f4908d04e6c6e657ce2e14e77c8823b0"

  bottle do
    sha256 "65370fb85df2d558595ddea8177a3ae8e9841ecd703b409779450146598e95b1" => :high_sierra
    sha256 "9b393529595e9045fa451a7d550babb03bb0fec79a94f820d107b0989ed076c4" => :sierra
    sha256 "0c9dd03afa5520fafdc6f9829262f2e159ff598a1fa8c7ac8c6f86225ba00bf3" => :el_capitan
  end

  option "with-jvm", "Build also for jvm as an alternate backend."

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "libffi"

  conflicts_with "parrot"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    backends = ["moar"]
    generate = ["--gen-moar"]

    backends << "jvm" if build.with? "jvm"

    system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=" + backends.join(","), *generate
    system "make"
    system "make", "install"

    # Panda is now in share/perl6/site/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
