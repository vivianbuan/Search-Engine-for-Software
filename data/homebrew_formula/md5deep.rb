class Md5deep < Formula
  desc "Recursively compute digests on files/directories"
  homepage "https://github.com/jessek/hashdeep"
  url "https://github.com/jessek/hashdeep/archive/release-4.4.tar.gz"
  sha256 "dbda8ab42a9c788d4566adcae980d022d8c3d52ee732f1cbfa126c551c8fcc46"
  head "https://github.com/jessek/hashdeep.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f5636f7731398f775d757cb4ae913762f725d4d7bd3060a2640c155207d7a2a" => :high_sierra
    sha256 "4ee90230c25f9872541d3f895fbe010765dd2e5449e56a0987e3652f89014916" => :sierra
    sha256 "986dad46d2945aac775eb625e41b0236f2413b3924244d5e9aba445994c38687" => :el_capitan
    sha256 "227b8b8e4f4dd71972cd02062faefef90515b44ef5c3ce55f5c665cf679a26d1" => :yosemite
    sha256 "1bacd45d420975ff8b90d633e361b54c7f6a14776a41f175313360d31fb03ba4" => :mavericks
    sha256 "5d68af238b95cffd8959418d804212c50a69cbae90c203d4abb56ceafea93399" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  # Fix compilation error due to pointer comparison
  if MacOS.version >= :high_sierra
    patch do
      url "https://github.com/jessek/hashdeep/pull/361.diff?full_index=1"
      sha256 "26af2c70fc573bbe09cf67af7fd9d121799771b448a460ee0efa958cbd80e584"
    end
  end

  def install
    system "sh", "bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    # Do not reduce the spacing of the below text.
    assert_equal "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32  testfile.txt",
    shell_output("#{bin}/sha1deep -b testfile.txt").strip
  end
end
