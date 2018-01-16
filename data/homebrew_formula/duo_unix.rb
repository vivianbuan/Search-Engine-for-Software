class DuoUnix < Formula
  desc "Two-factor authentication for SSH"
  homepage "https://www.duosecurity.com/docs/duounix"
  url "https://dl.duosecurity.com/duo_unix-1.10.1.tar.gz"
  sha256 "e2df2be50539c54c87cdc4964fdfee0fbd79a3f15fdfd807e94941291b5d6197"

  bottle do
    sha256 "5faadc10745090796bc019256039765927f2b4f2c296901f62d67a6026b87562" => :high_sierra
    sha256 "3e57a037c2a38a4268c44c9dd1c64e8c16a88238d4d2d059532c18ebf5b0f2f4" => :sierra
    sha256 "fb3f8c6f09739346d79458813db607007cfc9c3470c0ee33c95cdad0b5b32912" => :el_capitan
    sha256 "49ef30c2dc72644b3073a6fef31383cd6a558236ffb046c2c988d7805c4d4c1d" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--includedir=#{include}/duo",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--with-pam=#{lib}/pam/"
    system "make", "install"
  end

  test do
    system "#{sbin}/login_duo", "-d", "-c", "#{etc}/login_duo.conf",
                                "-f", "foobar", "echo", "SUCCESS"
  end
end
