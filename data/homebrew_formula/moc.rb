class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net"
  url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
  sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"
  revision 2

  bottle do
    sha256 "44bdffa1f83c2ce249d9d402fa3956b12f49ae63b702b849f01b93bd1c3fe433" => :high_sierra
    sha256 "85dd651a6ceffd30d05c41570b2c81c0eeb7211f3f8f63afc4580272c619df72" => :sierra
    sha256 "87493722fdef24873f9a2f9900a1cf5a4758c7b76f5c648668bd8ce1932076a3" => :el_capitan
  end

  devel do
    url "http://ftp.daper.net/pub/soft/moc/unstable/moc-2.6-alpha3.tar.xz"
    sha256 "a27b8888984cf8dbcd758584961529ddf48c237caa9b40b67423fbfbb88323b1"

    # Patch for clock_gettime issue
    # https://moc.daper.net/node/1576
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/78d5908905c6848bb75ae41b70d6bbb46abaa69b/moc/r2936-clock_gettime.patch"
      sha256 "601b5cdf59db67f180f1aaa6cc90804c1cb69c44cdecb2e8149338782e4f21a8"
    end

    # Remove build deps when 2.6-alpha4 comes out
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "popt"
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "popt"
  end

  option "with-ncurses", "Build with wide character support."

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "berkeley-db"
  depends_on "jack"
  depends_on "ffmpeg" => :recommended
  depends_on "mad" => :optional
  depends_on "flac" => :optional
  depends_on "speex" => :optional
  depends_on "musepack" => :optional
  depends_on "libsndfile" => :optional
  depends_on "wavpack" => :optional
  depends_on "faad2" => :optional
  depends_on "timidity" => :optional
  depends_on "libmagic" => :optional
  depends_on "ncurses" => :optional

  def install
    # Remove build.devel? when 2.6-alpha4 comes out
    system "autoreconf", "-fvi" if build.head? || build.devel?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You must start the jack daemon prior to running mocp.
      If you need wide-character support in the player, for example
      with Chinese characters, you can install using
          --with-ncurses
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
