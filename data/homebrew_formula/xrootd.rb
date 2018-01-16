class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.0/xrootd-4.8.0.tar.gz"
  sha256 "0b59ada295341902ca01e9d23e29780fb8df99a6d2bd1c2d654e9bb70c877ad8"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "69895e7e0278612c4de5bfd16f4c9c46a724869e85e94e42a6562c87c3f7b13a" => :high_sierra
    sha256 "2a8c9481b78a9c66ed81d732f7b388617e3e2af6296d87d7ab0ed3bf57cd0e85" => :sierra
    sha256 "86b0e5d163df416159ce96c39bc48f0e73e10539ba616fd35f78af66504c252c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
