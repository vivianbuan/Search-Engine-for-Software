class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.2.tar.xz"
  sha256 "5046cb471d422dbe948b5f5dd4e5552aaef52a0899c4b2688e5a68a556af7342"
  head "https://bitbucket.org/mpyne/game-music-emu.git"

  bottle do
    cellar :any
    sha256 "fa5d01d37320f200b61257cabe024ff4e51b801f37fcf217b455ba06abeca197" => :high_sierra
    sha256 "11069c82318a509cefef8132816ecac1e84d857fcc317532fbfd73b040c1e225" => :sierra
    sha256 "df8297b2e54ef3a24291d03006a4b0b9e2c7c004e3f9abe1f278a204a0efd031" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gme/gme.h>
      int main(void)
      {
        Music_Emu* emu;
        gme_err_t error;

        error = gme_open_data((void*)0, 0, &emu, 44100);

        if (error == gme_wrong_file_type) {
          return 0;
        } else {
          return -1;
        }
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
