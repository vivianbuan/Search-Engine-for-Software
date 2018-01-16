class SqliteAnalyzer < Formula
  desc "Analyze how space is allocated inside an SQLite file"
  homepage "https://www.sqlite.org/"
  url "https://www.sqlite.org/2017/sqlite-src-3210000.zip"
  version "3.21.0"
  sha256 "8681a34e059b30605f611ac85168ca54edbade50c71468b5882f5abbcd66b94e"

  bottle do
    cellar :any_skip_relocation
    sha256 "364f920740c6902f81389284f1fa84e9f39c51d1bd74e6979beda0a678091552" => :high_sierra
    sha256 "78c53b52a9426e91dc64b856a34bc8a1ad1ccb8afc4c3561823b9e163b91df3b" => :sierra
    sha256 "ceb9ed5f337ea2722070ccf33679b1a1aeea9f89b99c508e5e0cca50099f75e4" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--with-tcl=/System/Library/Frameworks/Tcl.framework/", "--prefix=#{prefix}"
    system "make", "sqlite3_analyzer"
    bin.install "sqlite3_analyzer"
  end

  test do
    dbpath = testpath/"school.sqlite"
    sqlpath = testpath/"school.sql"
    sqlpath.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
    EOS
    system "/usr/bin/sqlite3 #{dbpath} < #{sqlpath}"
    system bin/"sqlite3_analyzer", dbpath
  end
end
