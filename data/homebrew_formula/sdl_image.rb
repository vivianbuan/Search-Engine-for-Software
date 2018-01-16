class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 7

  bottle do
    cellar :any
    sha256 "eeb44401862df80a1d1f77dde4164b265d82993458325e753285566b56477695" => :high_sierra
    sha256 "d74d6e853e78b65a7e7f266be6733bdb5839f956bcb19061b68a46c16e080a94" => :sierra
    sha256 "4304e6b83a7afa176a0462e8ba20485bc098731a16bd375261f9f449a8f8f7d3" => :el_capitan
    sha256 "3403edd53a6776bad8dc4390ef8204479f3af7c485e8a7a1f81f86f43b4a7b5c" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  # Fix graphical glitching
  # https://github.com/Homebrew/homebrew-python/issues/281
  # https://trac.macports.org/ticket/37453
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/41996822/sdl_image/IMG_ImageIO.m.patch"
    sha256 "c43c5defe63b6f459325798e41fe3fdf0a2d32a6f4a57e76a056e752372d7b09"
  end

  def install
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-imageio
      --disable-sdltest
    ]

    args << "--disable-png-shared" if build.with? "libpng"
    args << "--disable-jpg-shared" if build.with? "jpeg"
    args << "--disable-tif-shared" if build.with? "libtiff"
    args << "--disable-webp-shared" if build.with? "webp"

    system "./configure", *args
    system "make", "install"
  end
end
