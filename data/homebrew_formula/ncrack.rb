class Ncrack < Formula
  desc "Network authentication cracking tool"
  homepage "https://nmap.org/ncrack/"
  url "https://github.com/nmap/ncrack/archive/v0.6.0.tar.gz"
  sha256 "676a323b1e9066193461f25e31445262bae495fde7dfcaf56555c3056dae24cc"
  head "https://github.com/nmap/ncrack.git"

  bottle do
    sha256 "710a7c1bbc131cce0e0b5ceac7bee02c829362489a56a881b2011df7bcab7dfb" => :high_sierra
    sha256 "887e071b2c1468c82c1d4ab390f0bbb6c03a482f0c39e89a573105d2ce5cb38c" => :sierra
    sha256 "1ca0625ada66ae28f5bc488ecc7ca246d68711ab6b314c4f6998ab47ccba1ec0" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_f.to_s, shell_output(bin/"ncrack --version")
  end
end
