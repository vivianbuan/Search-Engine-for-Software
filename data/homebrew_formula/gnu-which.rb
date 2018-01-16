class GnuWhich < Formula
  desc "GNU implementation of which utility"
  # Previous homepage is dead. Have linked to the GNU Projects page for now.
  homepage "https://savannah.gnu.org/projects/which/"
  url "https://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/which/which-2.21.tar.gz"
  sha256 "f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad"

  bottle do
    cellar :any_skip_relocation
    sha256 "3932d82472cb95be1af5692a3cdaf55b841f2799f80271ffb2ff22b940210dbc" => :high_sierra
    sha256 "ad546f7de7825dfbadcfbadd27a493d8acdb44c4a7a6855d02473ef96fb2f716" => :sierra
    sha256 "c7ed10cf7ef215ef098e2e340d1f491037080acac59a38ade51088ebc09e71c4" => :el_capitan
    sha256 "469d61be66afe0da2758838d1bde62544a661691568eaa30bc4f5abc16402efc" => :yosemite
    sha256 "b2649bbc23e1b180e3a7b9d4f88765d674696468904b246d253a7ca39106af61" => :mavericks
    sha256 "5f9dc6704dbc7599c299c6e0dd186efe19d2cdf6680651010c7a9c3b377a983e" => :mountain_lion
  end

  deprecated_option "default-names" => "with-default-names"

  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gwhich", "gcc"
  end
end
