class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "http://www.freerdp.com/"
  revision 1

  stable do
    url "https://github.com/FreeRDP/FreeRDP/archive/1.0.2.tar.gz"
    sha256 "c0f137df7ab6fb76d7e7d316ae4e0ca6caf356e5bc0b5dadbdfadea5db992df1"

    patch do
      url "https://github.com/FreeRDP/FreeRDP/commit/1d3289.diff?full_index=1"
      sha256 "09628c01238615c425e35f287b46f100fddcc2e5fea0adc41416fecee8129731"
    end

    patch do
      url "https://github.com/FreeRDP/FreeRDP/commit/e32f9e.diff?full_index=1"
      sha256 "829ce02ff1e618a808d6d505b815168cdef9cf0012db25d5b8470657852be93b"
    end

    # https://github.com/FreeRDP/FreeRDP/pull/1682/files
    patch do
      url "https://gist.githubusercontent.com/bmiklautz/8832375/raw/ac77b61185d11aa69e5f6b5e88c0fa597c04d964/freerdp-1.0.2-osxversion-patch.diff"
      sha256 "2e8f68a0dbe6e2574dec3353e65a4f03d76a3398f8fac536fda08c24748aec2b"
    end
  end
  bottle do
    sha256 "849254a5206feace01a07302a2e483c82cdc2403b85c6ad6a13917da19a53fb4" => :high_sierra
    sha256 "429e7a072afb895dbb2dd35a5d0ec64d6225c42af1e81c415454edd94336a5cf" => :sierra
    sha256 "6f7c7f1ccfe392cdd983e53ff662f7dae3c2ea94f47637760dc2e41fb707f172" => :el_capitan
    sha256 "a371c32a6fd8c6ccd28dad7260ecc84b042128f157aa85f2e2ffe9efcc19e0bc" => :yosemite
  end

  devel do
    url "https://github.com/FreeRDP/FreeRDP/archive/4c69c3ea1489f09e1c3e698eaebd67b6d8d25785.tar.gz" # stable-1.1 branch as of Aug 13, 2016
    sha256 "1a4b03daca9bd82ef2e3827e1cdb469121f62aab1061f79ffa587babf9fe080c"
    version "1.1.0-beta1"
    depends_on :xcode => :build # for "ibtool"

    patch do
      url "https://github.com/untoldone/FreeRDP/commit/65e53694eb5d6faa5d57a31a54defd1c5233ac09.diff?full_index=1"
      sha256 "a017305311312006d253908615a7af29c5f71a0cf2dcea1de9e35616a9df3d00"
    end
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on :xcode => :build
  end

  depends_on :x11
  depends_on "openssl"
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DWITH_X11=ON" << "-DBUILD_SHARED_LIBS=ON" if build.head? || build.devel?
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    if !success && details.exitstatus != 128
      raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp"
    end
  end
end
