class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "http://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.6/advancemame-3.6.tar.gz"
  sha256 "6759dd524bfdf071ceb95a56df87464693a3c62df7cc3127acc7e83f9f4606cf"

  bottle do
    sha256 "fa66fa22aa3e275bd8583113e0943590d2b8fe92d31283ca658937d44331feef" => :high_sierra
    sha256 "68ab0490dc3beebf944a884fe1ae0b97bf05a797bfae462450cd964ac0a97831" => :sierra
    sha256 "34e74bd32f1802e7a05683cfaee3147bd90fb1c6d10e75be40074b0495fdf97c" => :el_capitan
  end

  depends_on "sdl"
  depends_on "freetype"

  conflicts_with "advancemenu", :because => "both install `advmenu` binaries"

  def install
    ENV.delete "SDKROOT" if MacOS.version == :yosemite
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
