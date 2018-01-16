class Mairix < Formula
  desc "Email index and search tool"
  homepage "http://www.rpcurnow.force9.co.uk/mairix/"
  url "https://downloads.sourceforge.net/project/mairix/mairix/0.24/mairix-0.24.tar.gz"
  sha256 "a0702e079c768b6fbe25687ebcbabe7965eb493d269a105998c7c1c2caef4a57"

  head "https://github.com/rc0/mairix.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5975d9e5b741611279f008a50febebfa9d91c4e3e8448c4d8eda80cbd5c371af" => :high_sierra
    sha256 "9cfafed3ea8980b65d1fa5910db71468b3dfd5b81b598d20ff1bf317c55edbca" => :sierra
    sha256 "207bd087f9675c188a430ead82700870c9d3088597a788c334d020d92148caa8" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
