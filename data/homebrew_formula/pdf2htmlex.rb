class Pdf2htmlex < Formula
  desc "PDF to HTML converter"
  homepage "https://coolwanglu.github.io/pdf2htmlEX/"
  url "https://github.com/coolwanglu/pdf2htmlEX/archive/v0.14.6.tar.gz"
  sha256 "320ac2e1c2ea4a2972970f52809d90073ee00a6c42ef6d9833fb48436222f0e5"
  revision 19

  head "https://github.com/coolwanglu/pdf2htmlEX.git"

  bottle do
    sha256 "574e689fb63bb3894ab79d7acf995198804e5f2c439021acbe9dbc3b2b1571f2" => :high_sierra
    sha256 "ad030adc56fdd5e2009e5f32c7260594aac595585592820e71f55a7167453907" => :sierra
    sha256 "990af7e7d61d9bc18b50a5b62532b257ec6a3b26f9bce0a3e6e0973305bc4c0c" => :el_capitan
  end

  depends_on :macos => :lion
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnu-getopt"
  depends_on "openjpeg" # for poppler
  depends_on "ttfautohint"

  # Fontforge dependencies
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :run
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pango"

  # Pdf2htmlex use an outdated, customised Fontforge installation.
  # See https://github.com/coolwanglu/pdf2htmlEX/wiki/Building
  resource "fontforge" do
    url "https://github.com/coolwanglu/fontforge.git", :branch => "pdf2htmlEX"
  end

  # Upstream issue "poppler 0.59.0 incompatibility"
  # Reported 4 Sep 2017 https://github.com/coolwanglu/pdf2htmlEX/issues/733
  resource "poppler" do
    url "https://poppler.freedesktop.org/poppler-0.57.0.tar.xz"
    sha256 "0ea37de71b7db78212ebc79df59f99b66409a29c2eac4d882dae9f2397fe44d8"
  end

  resource "poppler-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.8.tar.gz"
    sha256 "1096a18161f263cccdc6d8a2eb5548c41ff8fcf9a3609243f1b6296abdf72872"
  end

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    resource("fontforge").stage do
      # Fix for incomplete giflib 5 support, see
      # https://github.com/coolwanglu/pdf2htmlEX/issues/713
      inreplace "gutils/gimagereadgif.c", "DGifCloseFile(gif)", "DGifCloseFile(gif, NULL)"

      # Fix linker error; see: https://trac.macports.org/ticket/25012
      ENV.append "LDFLAGS", "-lintl"

      # Reset ARCHFLAGS to match how we build
      ENV["ARCHFLAGS"] = "-arch #{MacOS.preferred_arch}"

      system "./autogen.sh"
      system "./configure", "--prefix=#{libexec}/fontforge",
                            "--without-libzmq",
                            "--without-x",
                            "--without-iconv",
                            "--disable-python-scripting",
                            "--disable-python-extension"
      system "make"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/fontforge/lib/pkgconfig"
    ENV.prepend_path "PATH", "#{libexec}/fontforge/bin"

    resource("poppler").stage do
      inreplace "poppler.pc.in", "Cflags: -I${includedir}/poppler",
                                 "Cflags: -I${includedir}/poppler -I${includedir}"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/poppler",
                            "--enable-xpdf-headers",
                            "--enable-poppler-glib",
                            "--disable-gtk-test",
                            "--enable-introspection=no",
                            "--disable-poppler-qt4"
      system "make", "install"
      resource("poppler-data").stage do
        system "make", "install", "prefix=#{libexec}/poppler"
      end
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{libexec}/poppler/lib/pkgconfig"
    ENV.prepend_path "PATH", "#{libexec}/poppler/bin"

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2htmlEX", test_fixtures("test.pdf")
  end
end
