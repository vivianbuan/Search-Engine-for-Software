class Fmsx < Formula
  desc "MSX emulator"
  homepage "https://fms.komkon.org/fMSX/"
  url "https://fms.komkon.org/fMSX/fMSX46.zip"
  version "4.6"
  sha256 "07ac1a2728d5ebdafc5867c8935afdaaa9654832229461f2066b5efe968bcd59"

  bottle do
    cellar :any
    sha256 "ef9f89421934556b6c7ade31c4b027afa275e123cd32f2e1f1116cda38b8febb" => :high_sierra
    sha256 "8a0005dbba341780f5c384e0b7788e2cb7e0b93b2bb0efa89fccba2407fba619" => :sierra
    sha256 "c2dc81794aa3bbc933b97196e07292e484f480e69f8fd1aec3b62b12f3902f38" => :el_capitan
    sha256 "6fcd0c12e2aa9be7a21e35ad51f307d958abb7cefcec3f57cfe33746fac7777b" => :yosemite
  end

  depends_on :x11
  depends_on "pulseaudio"

  resource "msx-rom" do
    url "https://fms.komkon.org/fMSX/src/MSX.ROM"
    sha256 "999564a371dd2fdf7fbe8d853e82a68d557c27b7d87417639b2fa17704b83f78"
  end

  resource "msx2-rom" do
    url "https://fms.komkon.org/fMSX/src/MSX2.ROM"
    sha256 "4bc4ae85ca5f28246cd3e7b7e017d298ddd375603657f84ef2c7954bc2d9b919"
  end

  resource "msx2ext-rom" do
    url "https://fms.komkon.org/fMSX/src/MSX2EXT.ROM"
    sha256 "6c6f421a10c428d960b7ecc990f99af1c638147f747bddca7b0bf0e2ab738300"
  end

  resource "msx2p-rom" do
    url "https://fms.komkon.org/fMSX/src/MSX2P.ROM"
    sha256 "9501a609be7d92e53fbd75fa65c8317563035d617744664892863ed54463db51"
  end

  resource "msx2pext-rom" do
    url "https://fms.komkon.org/fMSX/src/MSX2PEXT.ROM"
    sha256 "36000685128f95ff515a128973f8d439116c1a1a8e38c1777293a428894434a2"
  end

  resource "fmpac-rom" do
    url "https://fms.komkon.org/fMSX/src/FMPAC.ROM"
    sha256 "3cfe44646b69a622656b96305f1b975f48ca018839f7946895f7a1352d9720aa"
  end

  resource "disk-rom" do
    url "https://fms.komkon.org/fMSX/src/DISK.ROM"
    sha256 "31740a761447d7590c304338d389b0ae114546a8b9f79c9ffd5e374f80b7d354"
  end

  resource "msxdos2-rom" do
    url "https://fms.komkon.org/fMSX/src/MSXDOS2.ROM"
    sha256 "08d582fda65f22e4397353855e828539a64df08a540e5d64706b3362ea09be17"
  end

  resource "painter-rom" do
    url "https://fms.komkon.org/fMSX/src/PAINTER.ROM"
    sha256 "62e646cc9f0d50422016f12a77995be5547649b5961b58c883ff4d48baac280f"
  end

  resource "kanji-rom" do
    url "https://fms.komkon.org/fMSX/src/KANJI.ROM"
    sha256 "56785703b14f252ce77be586716dbf5d94125e93b9e6069ff26f7686566cd91a"
  end

  def install
    chdir "fMSX/Unix" do
      inreplace "Makefile" do |s|
        pa = Formula["pulseaudio"]
        s.gsub! %r{(DEFINES\s*\+=\s*[-\/$()\w\t ]*)}, "\\1 -DPULSE_AUDIO"
        s.gsub! %r{(CFLAGS\s*\+=\s*[-\/$()\w\t ]*)}, "\\1 -I#{pa.include}\nLIBS += -L#{pa.lib} -lpulse-simple"
      end
      system "make"
      bin.install "fmsx"
    end
    pkgshare.install "fMSX/Unix/CARTS.SHA"
    resources.each { |r| pkgshare.install r }
  end

  def caveats; <<~EOS
    No sound under OS X due to missing /dev/dsp.
    Bundled ROM files are located the following directory:
      #{pkgshare}
    You may want to use this directory to set `-home` option.
    EOS
  end

  test do
    system "#{bin}/fmsx", "-help"
  end
end
