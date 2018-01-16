class LibbitcoinBlockchain < Formula
  desc "Bitcoin Blockchain Library"
  homepage "https://github.com/libbitcoin/libbitcoin-blockchain"
  url "https://github.com/libbitcoin/libbitcoin-blockchain/archive/v3.4.0.tar.gz"
  sha256 "65251a7148ec9fc8456f924e6319194fc38771c192326b2daf1d4abca2f55c76"
  revision 1

  bottle do
    sha256 "a6a54ffe4cced097f4cfad6cfdf6fac490223347beafffe02ddf3eb49c510acc" => :high_sierra
    sha256 "250faa96a14677a832a3bb7d9d1b83e2d8a0cd839bebbf6bd0dcf6e552b24fa0" => :sierra
    sha256 "efcd19f33da698f17362e44b44fb6432cb6c3b4a10aaea1e7164f4fbc364bfac" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "libbitcoin-database"

  resource "libbitcoin-consensus" do
    url "https://github.com/libbitcoin/libbitcoin-consensus/archive/v3.4.0.tar.gz"
    sha256 "1393811593d85074d1207c25d3c8d6ae23efa5735d548244345652e5ef7b3f50"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("libbitcoin-consensus").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <bitcoin/blockchain.hpp>
      int main() {
        static const auto default_block_hash = libbitcoin::hash_literal("14508459b221041eab257d2baaa7459775ba748246c8403609eb708f0e57e74b");
        const auto block = std::make_shared<const libbitcoin::message::block>();
        libbitcoin::blockchain::block_entry instance(block);
        assert(instance.block() == block);
        assert(instance.hash() == default_block_hash);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp",
                    "-I#{libexec}/include",
                    "-L#{lib}", "-L#{libexec}/lib",
                    "-lbitcoin", "-lbitcoin-blockchain", "-lboost_system",
                    "-o", "test"
    system "./test"
  end
end
