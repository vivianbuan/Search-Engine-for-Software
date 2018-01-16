class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "http://doc.in2p3.fr/bbftp/"
  url "http://doc.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  mirror "http://ftp.riken.jp/net/bbftp/bbftp-client-3.2.1.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  revision 1

  bottle do
    sha256 "e95d1e5e6ea17e93d635f900d0ee4517587b9ea076fb2f6c8eaa96bae8e002e1" => :high_sierra
    sha256 "027138bf779c95260fe90d543c9c5767c32c8f7c1afeb4c6ad872ecfdffc0a9b" => :sierra
    sha256 "d813b37a04edcd071198dacd750fbac54fa3cd692fb7dda774aae88c5b8a2d9f" => :el_capitan
    sha256 "d1b3299d2308aac2881b5049e55e912e871e98fe44a4d3586ad6afc4a565d2e6" => :yosemite
    sha256 "8619a2f08f735d7e2387ba67ca53bf6f503f37835db08b127033d5c66019688d" => :mavericks
    sha256 "613133ffd2d9eb3d064a7ecfd12939655362d9d6f7c951f93260c0a47ddd835c" => :mountain_lion
  end

  depends_on "openssl"

  def install
    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if MacOS.version >= :yosemite

    cd "bbftpc" do
      system "./configure", "--disable-debug", "--disable-dependency-tracking",
                            "--with-ssl=#{Formula["openssl"].opt_prefix}", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end
