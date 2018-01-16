class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.27.1.tar.gz"
  sha256 "b967af98bd02e4c6a26f38b48a095e3445d98e50d6074cce2d2f573c89b58d4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd8640517f2524e78dff765935f326b6d45be8130e16fd1fa39d4b72a69de71b" => :high_sierra
    sha256 "6da102d391d4082aab831b72e9792cb4ddc62efa4a7da3fd20ff6fa2d628a0cf" => :sierra
    sha256 "07dd1348e7b8d7f61da8333176edfcef2efff50b3fe055330525a3de522b0fd2" => :el_capitan
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
