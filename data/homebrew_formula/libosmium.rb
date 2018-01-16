class Libosmium < Formula
  desc "Fast and flexible C++ library for working with OpenStreetMap data"
  homepage "http://osmcode.org/libosmium/"
  url "https://github.com/osmcode/libosmium/archive/v2.13.1.tar.gz"
  sha256 "a73cd56838a7438bd9ed208c9ce6794e2d55a1854039c4277a0c160d5071b909"

  bottle do
    cellar :any_skip_relocation
    sha256 "2310327bcf2f8e1cc4937da5a7cd7ba526fb8e73435febcb7b5c3e6d879b8ef4" => :high_sierra
    sha256 "e63f94d42eaf9143c6a8641e365a0fd0ca99281995e647c4964660ef40fb72eb" => :sierra
    sha256 "e63f94d42eaf9143c6a8641e365a0fd0ca99281995e647c4964660ef40fb72eb" => :el_capitan
    sha256 "e63f94d42eaf9143c6a8641e365a0fd0ca99281995e647c4964660ef40fb72eb" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "boost" => :build
  depends_on "google-sparsehash" => :optional
  depends_on "expat" => :optional
  depends_on "gdal" => :optional
  depends_on "proj" => :optional
  depends_on "doxygen" => :optional

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DINSTALL_GDALCPP=ON", "-DINSTALL_PROTOZERO=ON", "-DINSTALL_UTFCPP=ON", ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.osm").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <osm version="0.6" generator="handwritten">
        <node id="1" lat="0.001" lon="0.001" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <node id="2" lat="0.002" lon="0.002" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z"></node>
        <way id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <nd ref="1"/>
          <nd ref="2"/>
          <tag k="name" v="line"/>
        </way>
        <relation id="1" user="Dummy User" uid="1" version="1" changeset="1" timestamp="2015-11-01T19:00:00Z">
          <member type="node" ref="1" role=""/>
          <member type="way" ref="1" role=""/>
        </relation>
      </osm>
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <cstdlib>
      #include <iostream>
      #include <osmium/io/xml_input.hpp>

      int main(int argc, char* argv[]) {
        osmium::io::File input_file{argv[1]};
        osmium::io::Reader reader{input_file};
        while (osmium::memory::Buffer buffer = reader.read()) {}
        reader.close();
      }
    EOS

    system ENV.cxx, "-std=c++11", "-stdlib=libc++", "-lexpat", "-o", "libosmium_read", "test.cpp"
    system "./libosmium_read", "test.osm"
  end
end
