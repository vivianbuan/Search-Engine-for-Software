class GnupgAT14 < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-1.4.22.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.22.tar.bz2"
  sha256 "9594a24bec63a21568424242e3f198b9d9828dea5ff0c335e47b06f835f930b4"

  bottle do
    sha256 "a2a568ff85ea47d7486fcc0403332004af5230132fb5f9c17afbfa9279299eee" => :high_sierra
    sha256 "b34d26fe050fbb87ee0e5e002b1b1d1e5738dd695dc0a02c1b57bb3503ce092b" => :sierra
    sha256 "4ee6d442e1cb7636c0669cd4a9e83af555c1c5a9cb502405c54a575195884979" => :el_capitan
    sha256 "68e1c879a85d9e9ce68dc0b1bfa338a04cec76f8293911d335e1c1ae059bdd65" => :yosemite
  end

  depends_on "curl" if MacOS.version <= :mavericks
  depends_on "libusb-compat" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-asm
      --program-suffix=1
    ]
    args << "--with-libusb=no" if build.without? "libusb-compat"

    system "./configure", *args
    system "make"
    system "make", "check"

    # we need to create these directories because the install target has the
    # dependency order wrong
    [bin, libexec/"gnupg"].each(&:mkpath)
    system "make", "install"

    # https://lists.gnupg.org/pipermail/gnupg-devel/2016-August/031533.html
    inreplace bin/"gpg-zip1", "GPG=gpg", "GPG=gpg1"

    # Although gpg2 support should be pretty universal these days
    # keep vanilla `gpg` executables available, at least for now.
    %w[gpg-zip1 gpg1 gpgsplit1 gpgv1].each do |cmd|
      (libexec/"gpgbin").install_symlink bin/cmd => cmd.to_s.sub(/1/, "")
    end
  end

  def caveats; <<~EOS
    This formula does not install either `gpg` or `gpgv` executables into
    the PATH.

    If you simply require `gpg` and `gpgv` executables without explicitly
    needing GnuPG 1.x we recommend:
      brew install gnupg

    If you really need to use these tools without the "1" suffix you can
    add a "gpgbin" directory to your PATH from your #{shell_profile} like:

        PATH="#{opt_libexec}/gpgbin:$PATH"

    Note that doing so may interfere with GPG-using formulae installed via
    Homebrew.
    EOS
  end

  test do
    (testpath/"batchgpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %commit
    EOS
    system bin/"gpg1", "--batch", "--gen-key", "batchgpg"
    (testpath/"test.txt").write "Hello World!"
    system bin/"gpg1", "--armor", "--sign", "test.txt"
    system bin/"gpg1", "--verify", "test.txt.asc"
  end
end
