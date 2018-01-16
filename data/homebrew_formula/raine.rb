class Raine < Formula
  desc "680x0 arcade emulator"
  homepage "https://raine.1emulation.com/"
  url "https://github.com/zelurker/raine/archive/0.64.13.tar.gz"
  sha256 "0af13e67744ac81f987687a3f83703bc844897a6a1b828a19d82f96dfe8ab719"
  head "https://github.com/zelurker/raine.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5c3d0fa6dcef53ac42e2ca4b54ae91f4cbbdf83e3614056c3c6b58a2b6083db2" => :high_sierra
    sha256 "74e67059ae1ba9105c47aef4d46b871273023c2778f2cc939e9e6e2dd9020114" => :sierra
    sha256 "6cbc1585005c114105d1dfc758b3e522df63970086a79feaefeb8c496bf041e8" => :el_capitan
  end

  def configure_args(package)
    {
      "flac"      => %w[--disable-dependency-tracking
                        --disable-debug
                        --enable-static
                        --disable-asm-optimizations],
      "freetype"  => %w[--without-harfbuzz],
      "gettext"   => %w[--disable-dependency-tracking
                        --disable-silent-rules
                        --disable-debug
                        --with-included-gettext
                        --with-included-glib
                        --with-included-libcroco
                        --with-included-libunistring
                        --without-emacs
                        --disable-java
                        --disable-csharp
                        --without-git
                        --without-cvs
                        --without-xz],
      "muparser"  => %w[--disable-debug
                        --disable-dependency-tracking
                        --disable-shared
                        --disable-samples],
      "sdl"       => %w[--without-x],
      "sdl_image" => %w[--disable-dependency-tracking
                        --disable-imageio
                        --disable-sdltest],
      "sdl_sound" => %w[--disable-dependency-tracking
                        --disable-sdltest
                        --disable-mikmod
                        --disable-modplug
                        --disable-physfs
                        --disable-speex],
      "sdl_ttf"   => %W[--disable-debug
                        --disable-dependency-tracking
                        --disable-sdltest
                        --with-freetype-prefix=#{buildpath}],
    }.fetch(package, %w[--disable-debug
                        --disable-dependency-tracking
                        --disable-shared]).dup
  end

  depends_on "nasm" => :build
  depends_on "pkg-config" => :build

  resource "gettext" do
    url "https://ftp.gnu.org/gnu/gettext/gettext-0.19.8.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/gettext/gettext-0.19.8.1.tar.xz"
    sha256 "105556dbc5c3fbbc2aa0edb46d22d055748b6f5c7cd7a8d99f8e7eb84e938be4"
  end

  resource "libpng" do
    url "https://downloads.sourceforge.net/project/libpng/libpng16/older-releases/1.6.31/libpng-1.6.31.tar.xz"
    mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.31.tar.xz"
    sha256 "232a602de04916b2b5ce6f901829caf419519e6a16cc9cd7c1c91187d3ee8b41"
  end

  resource "sdl" do
    url "https://www.libsdl.org/release/SDL-1.2.15.tar.gz"
    sha256 "d6d316a793e5e348155f0dd93b979798933fb98aa1edebcc108829d6474aad00"
  end

  resource "sdl_image" do
    url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
    sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  end

  resource "libogg" do
    url "https://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"
    sha256 "e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692"
  end

  resource "libvorbis" do
    url "https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
    sha256 "54f94a9527ff0a88477be0a71c0bab09a4c3febe0ed878b24824906cd4b0e1d1"
  end

  resource "flac" do
    url "https://downloads.xiph.org/releases/flac/flac-1.3.2.tar.xz"
    mirror "https://downloads.sourceforge.net/project/flac/flac-src/flac-1.3.2.tar.xz"
    sha256 "91cfc3ed61dc40f47f050a109b08610667d73477af6ef36dcad31c31a4a8d53f"
  end

  resource "sdl_sound" do
    url "https://icculus.org/SDL_sound/downloads/SDL_sound-1.0.3.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/s/sdl-sound1.2/sdl-sound1.2_1.0.3.orig.tar.gz"
    sha256 "3999fd0bbb485289a52be14b2f68b571cb84e380cc43387eadf778f64c79e6df"
  end

  resource "freetype" do
    url "https://downloads.sourceforge.net/project/freetype/freetype2/2.8/freetype-2.8.tar.bz2"
    mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.8.tar.bz2"
    sha256 "a3c603ed84c3c2495f9c9331fe6bba3bb0ee65e06ec331e0a0fb52158291b40b"
  end

  resource "sdl_ttf" do
    url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
    sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"
  end

  resource "muparser" do
    url "https://github.com/beltoforion/muparser/archive/v2.2.5.tar.gz"
    sha256 "0666ef55da72c3e356ca85b6a0084d56b05dd740c3c21d26d372085aa2c6e708"
  end

  # Fix build for Xcode 9 with upstream commit
  # https://github.com/zelurker/raine/pull/13
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://github.com/zelurker/raine/commit/662cad1b.patch?full_index=1"
      sha256 "08ec83482318d9e58713f272ca882b5d658c03fd8df24bdb0008a56fa3310dd2"
    end
  end

  def install
    ENV.m32

    ENV.prepend_create_path "PATH", buildpath/"bin"
    ENV.append_to_cflags "-I#{buildpath}/include"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"lib/pkgconfig"

    # Install private copies of all dependencies in buildpath
    resources.each do |r|
      r.stage do
        # this sucks; we can't apply real patches since this is a resource
        if r.name == "sdl"
          inreplace "src/video/quartz/SDL_QuartzVideo.h",
                    /(CGDirectPaletteRef.+)$/,
                    "#if (MAC_OS_X_VERSION_MIN_REQUIRED < 1070)\n\\1\n#endif"
        elsif r.name == "sdl_ttf"
          inreplace "SDL_ttf.c",
                    "for ( row = 0; row < glyph->bitmap.rows; ++row ) {",
                    "for ( row = 0; row < glyph->pixmap.rows; ++row ) {"
        end

        args = configure_args(r.name)
        args << "--prefix=#{buildpath}"

        system "./configure", *args
        system "make"
        system "make", "install"
      end
    end

    inreplace "makefile" do |s|
      s.gsub! /-framework SDL_ttf/, "#{buildpath}/lib/libSDL_ttf.a #{buildpath}/lib/libfreetype.a -lbz2"
      s.gsub! /-framework (SDL_image|SDL)/, "#{buildpath}/lib/lib\\1.a"
      s.gsub! %r{/usr/local/lib/libSDL_sound\.a}, "#{buildpath}/lib/libSDL_sound.a"
      s.gsub! %r{/usr/local/lib/libintl\.a}, "#{buildpath}/lib/libintl.a"
      s.gsub! %r{/usr/local/lib/libmuparser\.a}, "#{buildpath}/lib/libmuparser.a"
      s.gsub! %r{/usr/local/lib/libpng.a}, "#{buildpath}/lib/libpng.a"
      s.gsub! %r{-I/usr/local/include}, ENV.cflags
    end

    # We need to manually pass the system frameworks that the SDL libraries
    # normally link against, since they're still used when linked statically.
    frameworks = %w[ApplicationServices AppKit AudioToolbox AudioUnit Carbon
                    CoreFoundation CoreGraphics CoreServices Foundation IOKit]

    system "make", "LD=#{ENV.cxx} #{ENV.ldflags} #{frameworks.map { |f| "-framework #{f}" }.join(" ")}"
    system "make", "install"
    prefix.install "Raine.app"
    bin.write_exec_script "#{prefix}/Raine.app/Contents/MacOS/raine"
  end

  test do
    assert_match /RAINE \(680x0 Arcade Emulation\) #{version} /, shell_output("#{bin}/raine -n")
  end
end
