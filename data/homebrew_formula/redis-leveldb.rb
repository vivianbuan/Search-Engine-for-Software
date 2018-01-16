class RedisLeveldb < Formula
  desc "Redis-protocol compatible frontend to leveldb"
  homepage "https://github.com/KDr2/redis-leveldb"
  url "https://github.com/KDr2/redis-leveldb/archive/v1.4.tar.gz"
  sha256 "b34365ca5b788c47b116ea8f86a7a409b765440361b6c21a46161a66f631797c"
  revision 3
  head "https://github.com/KDr2/redis-leveldb.git"

  bottle do
    cellar :any
    sha256 "9efe9023206565f3d5557202465fa99440262aef2298894c1f738dba0a39ad10" => :high_sierra
    sha256 "c8cdcf2f80de6eda4f86e9a7c6726ef1a2e046378a28b72b52deb180a15d1916" => :sierra
    sha256 "5373414613caf193828f782883f835858a8c999943a542e9ec3ff735a918bb63" => :el_capitan
    sha256 "4cf802ff434be42c86043c45f539cfdb0f137cfd37df4815560e3495da5f9d1b" => :yosemite
  end

  depends_on "libev"
  depends_on "gmp"
  depends_on "leveldb"
  depends_on "snappy"

  def install
    inreplace "src/Makefile", "../vendor/libleveldb.a", Formula["leveldb"].opt_lib+"libleveldb.a"
    ENV.prepend "LDFLAGS", "-lsnappy"
    system "make"
    bin.install "redis-leveldb"
  end

  test do
    system "#{bin}/redis-leveldb", "-h"
  end
end
