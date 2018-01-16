class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.4.tar.xz"
  sha256 "2cee38dd583ccbaa5bdf6c01ca5f88cc08758b9b144938a51a478eb2684b765e"
  revision 2

  bottle do
    sha256 "39e348596409d69d57609d0a00c6e9506a9fd52a4f90e585e3b6840bf03ea67e" => :high_sierra
    sha256 "e165830cedc3a0955989746145b310cc03fe96b84f18b33c4c3f2b827bdd473c" => :sierra
    sha256 "7809bb97ebcd233a740c1e5b5cb0f291a902639a6479d5e53fdcfedd928b6582" => :el_capitan
    sha256 "01e46f8673fcf3fad0bccdd70e9bd6fac08f0f5b7035e85318a3add4db329a9b" => :yosemite
  end

  # Fix incorrect encoding of headers
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=870741
  # https://bugzilla.gnome.org/show_bug.cgi?id=788283
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bf4e8e3395/libgda/encoding.patch"
    sha256 "db6c7f10a9ed832585aae65eb135b718a69c5151375aa21e475ba3031beb0068"
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "readline"
  depends_on "libgcrypt"
  depends_on "sqlite"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java"
    system "make"
    system "make", "install"
  end
end
