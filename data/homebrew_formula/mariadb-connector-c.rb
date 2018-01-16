class MariadbConnectorC < Formula
  desc "MariaDB database connector for C applications"
  homepage "https://downloads.mariadb.org/connector-c/"
  url "https://downloads.mariadb.org/f/connector-c-2.2.2/mariadb-connector-c-2.2.2-src.tar.gz"
  sha256 "93f56ad9f08bbaf0da8ef03bc96f7093c426ae40dede60575d485e1b99e6406b"

  bottle do
    sha256 "d569c9bbc70e38697625aaf1ff939689b1b7189d2fcf890546a72dc0e4d8f4c8" => :high_sierra
    sha256 "2efc882d3518dc6932d711b62d5d65a6b2151f7e44d2e6a15917ca4f1d3ce897" => :sierra
    sha256 "fe5606d7c8ac822398f01f2b2b9045c8d6b3a46df8b862e1fe151aa17619d3b2" => :el_capitan
    sha256 "6b5b743616a46585a9bfe1505a94addccf24802090094a9dcd791852bf8d566c" => :yosemite
    sha256 "14f9440a48d0035a8e77ff8e7b260b50c89326453041ec77d0cc38febbf4f5cc" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  conflicts_with "mysql", "mariadb", "percona-server",
                 :because => "both install plugins"

  def install
    args = std_cmake_args
    args << "-DWITH_OPENSSL=On"
    args << "-DOPENSSL_INCLUDE_DIR=#{Formula["openssl"].opt_include}"
    args << "-DCOMPILATION_COMMENT=Homebrew"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{bin}/mariadb_config", "--cflags"
  end
end
