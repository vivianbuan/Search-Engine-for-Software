class AcesContainer < Formula
  desc "Reference implementation of SMPTE ST2065-4"
  homepage "https://github.com/ampas/aces_container"
  url "https://github.com/ampas/aces_container/archive/v1.0.2.tar.gz"
  sha256 "cbbba395d2425251263e4ae05c4829319a3e399a0aee70df2eb9efb6a8afdbae"

  bottle do
    cellar :any
    sha256 "4297afa069f1cd305e93038ed43260b3643f0bd27f39e33355061fc111fb7f6f" => :high_sierra
    sha256 "6b276491297d4052538bd2fd22d5129389f27d90a98f831987236a5b90511b98" => :sierra
    sha256 "16cf230afdfcb6306c208d169549cf8773c831c8653d2c852315a048960d7e72" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
