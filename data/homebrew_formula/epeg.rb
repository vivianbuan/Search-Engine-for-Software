class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.2.tar.gz"
  sha256 "f8285b94dd87fdc67aca119da9fc7322ed6902961086142f345a39eb6e0c4e29"
  revision 1
  head "https://github.com/mattes/epeg.git"

  bottle do
    cellar :any
    sha256 "8ca494e4c2131e0b9c9e02199a26998f7f14e47cf00da9fbe7a5e75891d5fb94" => :high_sierra
    sha256 "a7d1777cff7684385a5a7d9c524a26e6f6509c80a638fadc99b6db84b96b1636" => :sierra
    sha256 "423a279278962dbc33e3e7ec0d7e9e81d497c7c69d7b4f24860630ae9c55b7a1" => :el_capitan
    sha256 "82b3b35c9aae9cbcfe6502489d04ec44a478d058261e8456cba79f791da70a92" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libexif"

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epeg", "--width=1", "--height=1", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
