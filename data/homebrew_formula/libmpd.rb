class Libmpd < Formula
  desc "Higher level access to MPD functions"
  homepage "https://gmpc.wikia.com/wiki/Gnome_Music_Player_Client"
  url "https://www.musicpd.org/download/libmpd/11.8.17/libmpd-11.8.17.tar.gz"
  sha256 "fe20326b0d10641f71c4673fae637bf9222a96e1712f71f170fca2fc34bf7a83"

  bottle do
    cellar :any
    rebuild 1
    sha256 "366b75cc5d921e946f5d987cb2627a9d66d04db36032ff98f5dd881ff0df754e" => :high_sierra
    sha256 "e5affb45da15f4b7df327b993216d44f76f88da1e8c2f1051a8045c63a5a9d04" => :sierra
    sha256 "d4b932dc975f7fe87d8e26ebe9080d3633c33a66438c29d0403160adb6c7ada5" => :el_capitan
    sha256 "36471b19608eea97bc9916fdb65937fbb385ade1bf43aac4c01031d3c3c1192f" => :yosemite
    sha256 "8e79457e677bf003a8e5374f1f7ccffba5ef237e577a0e0831ccb2036101b357" => :mavericks
    sha256 "85c97dbfb2a3a419495e702df451b00bf84e355d69c2e8512a54014ff702f45c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
