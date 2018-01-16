class Dbhash < Formula
  desc "Computes the SHA1 hash of schema and content of a SQLite database"
  homepage "https://www.sqlite.org/dbhash.html"
  url "https://www.sqlite.org/2017/sqlite-src-3210000.zip"
  version "3.21.0"
  sha256 "8681a34e059b30605f611ac85168ca54edbade50c71468b5882f5abbcd66b94e"

  bottle do
    cellar :any_skip_relocation
    sha256 "db96d6ab7752f0b0452d3973d0b6ac45bba1ea511db51e59df20bb7bef851eb7" => :high_sierra
    sha256 "36f7f808de9d1eb08231b68db17a2948b78876d4212031906db7a38359695d2a" => :sierra
    sha256 "578b82fbbb3bf80ebee8c5795e8754c6df451c23a273bda6732179b2f30cf71d" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "dbhash"
    bin.install "dbhash"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlpath.write "create table test (name text);"
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    assert_equal "b6113e0ce62c5f5ca5c9f229393345ce812b7309",
                 shell_output("#{bin}/dbhash #{dbpath}").strip.split.first
  end
end
