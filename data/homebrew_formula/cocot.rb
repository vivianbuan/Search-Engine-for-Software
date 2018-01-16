class Cocot < Formula
  desc "Code converter on tty"
  homepage "https://vmi.jp/software/cygwin/cocot.html"
  url "https://github.com/vmi/cocot/archive/cocot-1.2-20171118.tar.gz"
  sha256 "b718630ce3ddf79624d7dcb625fc5a17944cbff0b76574d321fb80c61bb91e4c"

  head "https://github.com/vmi/cocot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0070eb38e06043e3c1a4ad1b77205a6ed978ed300e8d0bb407391fecb191b050" => :high_sierra
    sha256 "a91ba93032e33b6a062b82f2df0b9170d5269cf0312d75eb6f16341fca54f9bd" => :sierra
    sha256 "60cbdadb074b019535319e5089d5c55c43b68e0b52a73b01cec3a9a8311e51a4" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
