class Mediatomb < Formula
  desc "Open source (GPL) UPnP MediaServer"
  homepage "https://mediatomb.cc/"
  url "https://downloads.sourceforge.net/mediatomb/mediatomb-0.12.1.tar.gz"
  sha256 "31163c34a7b9d1c9735181737cb31306f29f1f2a0335fb4f53ecccf8f62f11cd"
  revision 2

  bottle do
    rebuild 1
    sha256 "d4dee77311dda28a732947640b2adf9387f477ed9b66bc0640c30feba34b6a1d" => :high_sierra
    sha256 "8eb40e0276320c6765b7dbc208afe1c53a06ed13ff5e410e16aee57c366bede7" => :sierra
    sha256 "06cb4aaff088fc91d9500b10640d2b1632f8c88c95277f9cface991a06801ad6" => :el_capitan
    sha256 "089217abe05ea91a8dc1df796974495f87b8bcde7b4d80a93b1129e12cfc344d" => :yosemite
    sha256 "7022f700071652e20eb3d93b3d0b0a9d5f4cf1485cd350d85116fcbdea1ac104" => :mavericks
  end

  depends_on "libexif"
  depends_on "libmagic"
  depends_on "lzlib"
  depends_on "mp4v2"
  depends_on "spidermonkey"
  depends_on "sqlite"
  depends_on "taglib"
  depends_on "ffmpeg" => :optional
  depends_on "ffmpegthumbnailer" => :optional
  depends_on "id3lib" => :optional
  depends_on "mysql" => :optional

  # This is for libav 0.7 support. See:
  # https://bugs.launchpad.net/ubuntu/+source/mediatomb/+bug/784431
  # https://sourceforge.net/p/mediatomb/bugs/90/
  patch do
    url "https://launchpadlibrarian.net/71985647/libav_0.7_support.patch"
    sha256 "c6523e8bf5e2da89b7475d6777ef9bffe7d089752ef2f7b27b5e39a4130fb0ff"
  end

  patch do
    url "https://ftp.heanet.ie/mirrors/fink/finkinfo/10.7/stable/main/finkinfo/net/mediatomb.patch"
    sha256 "7e8ef3e1bec9a045549b468a3441f9d3d7bb42a7e77564a5fedea2d6024303ea"
  end

  patch do
    url "https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/net-misc/mediatomb/files/mediatomb-0.12.1-libav9.patch"
    sha256 "ae07427380e22f7340af28ea8d8d4bd01ec07f1c09bd0e0e50f310b2b4e507e2"
  end

  # Workaround for Samsung TV; upstream has accepted this patch
  # https://sourceforge.net/p/mediatomb/code/ci/2753e70013636bb5dd4cfc595f9776d368709f04
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/43c51305a0c4a9a78805f45e1cf1ff163847be4a/mediatomb/urifix.patch"
    sha256 "9cf68bc486eba9ae5f74b59ee2aeebf7e57263b47914136b5d0e24556f0c304f"
  end

  # Upstream patch: https://sourceforge.net/p/mediatomb/patches/35/
  patch do
    url "https://gist.githubusercontent.com/jacknagel/0971b2626b3a3c86c055/raw/31e568792918b57622dba559658e4161ad87f519/0010_fix_libmp4v2_build.patch"
    sha256 "8823da463d22c74b0a87a0054e1594e2fb8d418eff93b86e346e5506bb5a7323"
  end

  # Calling "include <new>" doesn't seem to make size_t available here.
  # Submitted upstream: https://sourceforge.net/p/mediatomb/patches/46
  # Seems to be related to this sort of error:
  # https://stackoverflow.com/questions/5909636/overloading-operator-new
  patch do
    url "https://sourceforge.net/p/mediatomb/patches/46/attachment/object.diff"
    sha256 "b289e77a5177aa66da45bdb50e5f04c94fb1b8d14c83faa72251ccae8680a1d3"
  end

  # FreeBSD patch to fix Clang compile.
  # https://svnweb.freebsd.org/ports/head/net/mediatomb/files/patch-timer.cc?revision=397755&view=markup
  # Noted here with the GCC patch: https://sourceforge.net/p/mediatomb/patches/46/#54bc
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d316eac2/mediatomb/timercc.diff"
    sha256 "e1ea57ca4b855b78c70de1e5041ecfa46521a19bd95d2594efe7e6f69014baca"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  def caveats; <<~EOS
    Edit the config file ~/.mediatomb/config.xml before running mediatomb.
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/mediatomb --ip 127.0.0.1 --port 49154"
    end
    sleep 2

    begin
      assert_match "file is part of MediaTomb", shell_output("curl 127.0.0.1:49154")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
