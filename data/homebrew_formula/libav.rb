class Libav < Formula
  desc "Audio and video processing tools"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.2.tar.xz"
  sha256 "7b5620261fb3e372bf3992736862f598967988502f7804c39c5246b62348c53b"

  head "https://git.libav.org/libav.git"

  bottle do
    sha256 "f5e07daaf273dfd195589bcad8c5b5ac76a2d2a5303f5049982d8571229e5588" => :high_sierra
    sha256 "eebcb1c507573e727c3c0fdaf71c7eacd3e812dd2291d9d810e351ba51d44a3d" => :sierra
    sha256 "2e1471577657408ca11733bab5324f6dcd8ee62db06fa8a0e1d28dc05498981b" => :el_capitan
  end

  option "without-faac", "Disable AAC encoder via faac"
  option "without-lame", "Disable MP3 encoder via libmp3lame"
  option "without-libvorbis", "Disable Vorbis encoding via libvorbis"
  option "without-libvpx", "Disable VP8 de/encoding via libvpx"
  option "without-x264", "Disable H.264 encoder via x264"
  option "without-xvid", "Disable Xvid MPEG-4 video encoder via xvid"

  option "with-opencore-amr", "Enable AMR-NB de/encoding and AMR-WB decoding " \
    "via libopencore-amrnb and libopencore-amrwb"
  option "with-openssl", "Enable SSL support"
  option "with-rtmpdump", "Enable RTMP protocol support"
  option "with-schroedinger", "Enable Dirac video format"
  option "with-sdl", "Enable avplay"
  option "with-speex", "Enable Speex de/encoding via libspeex"
  option "with-theora", "Enable Theora encoding via libtheora"
  option "with-libvo-aacenc", "Enable VisualOn AAC encoder"

  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  # manpages won't be built without texi2html
  depends_on "texi2html" => :build if MacOS.version >= :mountain_lion

  depends_on "faac" => :recommended
  depends_on "fdk-aac" => :recommended
  depends_on "freetype" => :recommended
  depends_on "lame" => :recommended
  depends_on "libvorbis" => :recommended
  depends_on "libvpx" => :recommended
  depends_on "opus" => :recommended
  depends_on "x264" => :recommended
  depends_on "xvid" => :recommended

  depends_on "fontconfig" => :optional
  depends_on "frei0r" => :optional
  depends_on "gnutls" => :optional
  depends_on "libvo-aacenc" => :optional
  depends_on "opencore-amr" => :optional
  depends_on "openssl" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sdl" => :optional
  depends_on "speex" => :optional
  depends_on "theora" => :optional

  # https://bugzilla.libav.org/show_bug.cgi?id=1033
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b6e917c/libav/Check-for--no_weak_imports-in-ldflags-on-macOS.patch"
    sha256 "986d748ba2c7c83319a59d76fbb0dca22dcd51f0252b3d1f3b80dbda2cf79742"
  end

  def install
    args = [
      "--disable-debug",
      "--disable-shared",
      "--disable-indev=jack",
      "--prefix=#{prefix}",
      "--enable-gpl",
      "--enable-nonfree",
      "--enable-version3",
      "--enable-vda",
      "--cc=#{ENV.cc}",
      "--host-cflags=#{ENV.cflags}",
      "--host-ldflags=#{ENV.ldflags}",
    ]

    args << "--enable-frei0r" if build.with? "frei0r"
    args << "--enable-gnutls" if build.with? "gnutls"
    args << "--enable-libfaac" if build.with? "faac"
    args << "--enable-libfdk-aac" if build.with? "fdk-aac"
    args << "--enable-libfontconfig" if build.with? "fontconfig"
    args << "--enable-libfreetype" if build.with? "freetype"
    args << "--enable-libmp3lame" if build.with? "lame"
    args << "--enable-libopencore-amrnb" if build.with? "opencore-amr"
    args << "--enable-libopencore-amrwb" if build.with? "opencore-amr"
    args << "--enable-libopus" if build.with? "opus"
    args << "--enable-librtmp" if build.with? "rtmpdump"
    args << "--enable-libschroedinger" if build.with? "schroedinger"
    args << "--enable-libspeex" if build.with? "speex"
    args << "--enable-libtheora" if build.with? "theora"
    args << "--enable-libvo-aacenc" if build.with? "libvo-aacenc"
    args << "--enable-libvorbis" if build.with? "libvorbis"
    args << "--enable-libvpx" if build.with? "libvpx"
    args << "--enable-libx264" if build.with? "x264"
    args << "--enable-libxvid" if build.with? "xvid"
    args << "--enable-openssl" if build.with? "openssl"

    system "./configure", *args

    system "make"

    bin.install "avconv", "avprobe"
    man1.install "doc/avconv.1", "doc/avprobe.1"
    if build.with? "sdl"
      bin.install "avplay"
      man1.install "doc/avplay.1"
    end
  end

  test do
    # Create an example mp4 file
    system "#{bin}/avconv", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert_predicate testpath/"video.mp4", :exist?
  end
end
