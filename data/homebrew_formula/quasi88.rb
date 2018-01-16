class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.6.4.tgz"
  sha256 "2c4329f9f77e02a1e1f23c941be07fbe6e4a32353b5d012531f53b06996881ff"

  bottle do
    cellar :any
    sha256 "8199a69a8ecad4247752091f3eeaf5181eaa1dd0e4b2670059e21df807c646c6" => :high_sierra
    sha256 "d9ff4c5657c4179371d60317e0455cbadd59d45d81d0cc71d62d14d681619e95" => :sierra
    sha256 "4bef6f92d4fcdf3547e0e7b9d699f392de0ff4764bbed0d8b23ea37e22e33f78" => :el_capitan
    sha256 "f9b4ef36396de67507df8148ad22ecca3940505c40468656df03ac685930b2d9" => :yosemite
  end

  depends_on "sdl"

  def install
    args = %W[
      X11_VERSION=
      SDL_VERSION=1
      ARCH=macosx
      SOUND_SDL=1
      LD=#{ENV.cxx}
      CXX=#{ENV.cxx}
      CXXLIBS=
    ]
    system "make", *args
    bin.install "quasi88.sdl" => "quasi88"
  end

  def caveats; <<~EOS
    You will need to place ROM and disk files.
    Default arguments for the directories are:
      -romdir ~/quasi88/rom/
      -diskdir ~/quasi88/disk/
      -tapedir ~/quasi88/tape/
    EOS
  end

  test do
    system "#{bin}/quasi88", "-help"
  end
end
