class Libhttpserver < Formula
  desc "C++ library of embedded Rest HTTP server"
  homepage "https://github.com/etr/libhttpserver"
  url "https://github.com/etr/libhttpserver/archive/v0.9.0.tar.gz"
  sha256 "fbdc0a44e92e78e8cc03b0a595e6190d2de002610a6467dc32d703e9c5486189"
  revision 1
  head "https://github.com/etr/libhttpserver.git"

  bottle do
    cellar :any
    sha256 "5dc4f569cf86961564e5954220d9049af40ef28796eefa350c12c6df8b32e45e" => :high_sierra
    sha256 "aac717fe37c9fa0491185e237100288f2d8ebe8544bfc16115f20b13fd242782" => :sierra
    sha256 "ee7c3025c9678a97f326c69a8a9faa4963eefc8f972c78096b3f237cf7368945" => :el_capitan
    sha256 "d6ec883a992e348d69b90c37b3c0f1ab2329cc9bae3cb8d1f1db7d112ca65200" => :yosemite
    sha256 "aec3bba3f8db0cb1e9fd99d66aafb1f2ed399197f11af43654f911205b62d5ee" => :mavericks
  end

  depends_on "libmicrohttpd"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    system "./bootstrap"
    mkdir "build" do
      system "../configure", *args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp",
      "-o", "hello_world", "-L#{lib}", "-lhttpserver", "-lcurl"
    pid = fork { exec "./hello_world" }
    sleep 1 # grace time for server start
    begin
      assert_match /Hello World!!!/, shell_output("curl http://127.0.0.1:8080/hello")
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
