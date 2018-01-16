class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"

  head "https://git.savannah.gnu.org/git/bash.git"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-4.4.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-4.4.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4.tar.gz"
    sha256 "d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
    version "4.4.12"

    %w[
      001 3e28d91531752df9a8cb167ad07cc542abaf944de9353fe8c6a535c9f1f17f0f
      002 7020a0183e17a7233e665b979c78c184ea369cfaf3e8b4b11f5547ecb7c13c53
      003 51df5a9192fdefe0ddca4bdf290932f74be03ffd0503a3d112e4199905e718b2
      004 ad080a30a4ac6c1273373617f29628cc320a35c8cd06913894794293dc52c8b3
      005 221e4b725b770ad0bb6924df3f8d04f89eeca4558f6e4c777dfa93e967090529
      006 6a8e2e2a6180d0f1ce39dcd651622fb6d2fd05db7c459f64ae42d667f1e344b8
      007 de1ccc07b7bfc9e25243ad854f3bbb5d3ebf9155b0477df16aaf00a7b0d5edaf
      008 86144700465933636d7b945e89b77df95d3620034725be161ca0ca5a42e239ba
      009 0b6bdd1a18a0d20e330cc3bc71e048864e4a13652e29dc0ebf3918bea729343c
      010 8465c6f2c56afe559402265b39d9e94368954930f9aa7f3dfa6d36dd66868e06
      011 dd56426ef7d7295e1107c0b3d06c192eb9298f4023c202ca2ba6266c613d170d
      012 fac271d2bf6372c9903e3b353cb9eda044d7fe36b5aab52f21f3f21cd6a2063e
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://gnu.cu.be/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    sha256 "177a1cfffc4158165d1fe1fc467dd07a5ba4ac4a94002b7b17e693b83cb7c98f" => :high_sierra
    sha256 "ac12c447d66bb79762b8f1494655f7631dc8967392c23efd0abf5ba7a1d44a7e" => :sierra
    sha256 "f35e631d1b87513743daacfb9cb798682ffb34f205290267c75b37169b1f3682" => :el_capitan
    sha256 "25ebb6b3ec589b0248b4e249adbbac409bdd3f7cd38346d070f6edf404729a31" => :yosemite
  end

  depends_on "readline"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end
