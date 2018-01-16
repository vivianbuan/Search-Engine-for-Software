class Libspatialite < Formula
  desc "Adds spatial SQL capabilities to SQLite"
  homepage "https://www.gaia-gis.it/fossil/libspatialite/index"
  revision 3

  stable do
    url "https://www.gaia-gis.it/gaia-sins/libspatialite-sources/libspatialite-4.3.0a.tar.gz"
    mirror "https://ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-4.3.0a.tar.gz"
    mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libspatialite-4.3.0a.tar.gz"
    sha256 "88900030a4762904a7880273f292e5e8ca6b15b7c6c3fb88ffa9e67ee8a5a499"

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/27a0e51936e01829d0a6f3c75a7fbcaf92bb133f/libspatialite/sqlite310.patch"
      sha256 "459434f5e6658d6f63d403a7795aa5b198b87fc9f55944c714180e7de662fce2"
    end
  end

  bottle do
    cellar :any
    sha256 "5a3b1a4c722b691a653797a4e15a1cd688a6c653cb4827eaf71b7d3d5fe9cb8e" => :high_sierra
    sha256 "2924b1b4d5856c3a8b2e84aaffcb296d5fd3bc81c05d74e7b5c1dba61cfa91a7" => :sierra
    sha256 "c394425fddfa6b821542c68e29d558646e54336322552a60b620dbe3e5bc2749" => :el_capitan
    sha256 "1c1627686a4d9a6969accae84e3a35414e076be0535fef01c1343fb54e4b18e9" => :yosemite
  end

  head do
    url "https://www.gaia-gis.it/fossil/libspatialite", :using => :fossil
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-freexl", "Build without support for reading Excel files"
  option "without-libxml2", "Disable support for xml parsing (parsing needed by spatialite-gui)"
  option "without-liblwgeom", "Build without additional sanitization/segmentation routines provided by PostGIS 2.0+ library"
  option "without-geopackage", "Build without OGC GeoPackage support"

  depends_on "pkg-config" => :build
  depends_on "proj"
  depends_on "geos"
  # Needs SQLite > 3.7.3 which rules out system SQLite on Snow Leopard and
  # below. Also needs dynamic extension support which rules out system SQLite
  # on Lion. Finally, RTree index support is required as well.
  depends_on "sqlite"
  depends_on "libxml2" => :recommended
  depends_on "freexl" => :recommended
  depends_on "liblwgeom" => :recommended

  def install
    system "autoreconf", "-fi" if build.head?

    # New SQLite3 extension won't load via SELECT load_extension("mod_spatialite");
    # unless named mod_spatialite.dylib (should actually be mod_spatialite.bundle)
    # See: https://groups.google.com/forum/#!topic/spatialite-users/EqJAB8FYRdI
    #      needs upstream fixes in both SQLite and libtool
    inreplace "configure",
              "shrext_cmds='`test .$module = .yes && echo .so || echo .dylib`'",
              "shrext_cmds='.dylib'"

    # Ensure Homebrew's libsqlite is found before the system version.
    sqlite = Formula["sqlite"]
    ENV.append "LDFLAGS", "-L#{sqlite.opt_lib}"
    ENV.append "CFLAGS", "-I#{sqlite.opt_include}"

    if build.with? "liblwgeom"
      lwgeom = Formula["liblwgeom"]
      ENV.append "LDFLAGS", "-L#{lwgeom.opt_lib}"
      ENV.append "CFLAGS", "-I#{lwgeom.opt_include}"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-sysroot=#{HOMEBREW_PREFIX}
      --enable-geocallbacks
    ]
    args << "--enable-freexl=no" if build.without? "freexl"
    args << "--enable-libxml2=no" if build.without? "libxml2"
    args << "--enable-lwgeom=yes" if build.with? "liblwgeom"
    args << "--enable-geopackage=no" if build.without? "geopackage"

    system "./configure", *args
    system "make", "install"
  end

  test do
    # Verify mod_spatialite extension can be loaded using Homebrew's SQLite
    pipe_output("#{Formula["sqlite"].opt_bin}/sqlite3",
      "SELECT load_extension('#{opt_lib}/mod_spatialite');")
  end
end
