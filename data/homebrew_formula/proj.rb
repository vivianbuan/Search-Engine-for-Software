class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "http://proj4.org"
  url "http://download.osgeo.org/proj/proj-4.9.3.tar.gz"
  sha256 "6984542fea333488de5c82eea58d699e4aff4b359200a9971537cd7e047185f7"

  bottle do
    sha256 "3bb7bda64844e30e4103a33e2bd15985359a90c1d8db7244bbd8055bb121b810" => :high_sierra
    sha256 "82ea2f4d18b24bf337bf10bbb42f3e7d98a24803db252c8ea0383873c1d944cc" => :sierra
    sha256 "4a18c02f82a4ee75c4cb61bb201bfe14d05fdf663781270ccaba6cad3cd3bc86" => :el_capitan
    sha256 "eecdee32c333c828b17c0246d2cdf0580f144029c43c278555f793c5e3fead02" => :yosemite
  end

  head do
    url "https://github.com/OSGeo/proj.4.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-vdatum", "Install vertical datum files (~380 MB)"

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "http://download.osgeo.org/proj/proj-datumgrid-1.5.zip"
    sha256 "723c4017d95d7a8abdf3bda4e18d3c15d79b00f9326d453da5fdf13f96c287db"
  end

  # Vertical datum files
  resource "usa_geoid2012" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2012.zip"
    sha256 "afe49dc2c405d19a467ec756483944a3c9148e8c1460cb7e82dc8d4a64c4c472"
  end

  resource "usa_geoid2009" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2009.zip"
    sha256 "1a232fb7fe34d2dad2d48872025597ac7696882755ded1493118a573f60008b1"
  end

  resource "usa_geoid2003" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid2003.zip"
    sha256 "1d15950f46e96e422ebc9202c24aadec221774587b7a4cd963c63f8837421351"
  end

  resource "usa_geoid1999" do
    url "http://download.osgeo.org/proj/vdatum/usa_geoid1999.zip"
    sha256 "665cd4dfc991f2517752f9db84d632b56bba31a1ed6a5f0dc397e4b0b3311f36"
  end

  resource "vertconc" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertconc.gtx"
    sha256 "ecf7bce7bf9e56f6f79a2356d8d6b20b9cb49743701f81db802d979b5a01fcff"
  end

  resource "vertcone" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertcone.gtx"
    sha256 "f6da1c615c2682ecb7adcfdf22b1d37aba2771c2ea00abe8907acea07413903b"
  end

  resource "vertconw" do
    url "http://download.osgeo.org/proj/vdatum/vertcon/vertconw.gtx"
    sha256 "de648c0f6e8b5ebfc4b2d82f056c7b993ca3c37373a7f6b7844fe9bd4871821b"
  end

  resource "egm96_15" do
    url "http://download.osgeo.org/proj/vdatum/egm96_15/egm96_15.gtx"
    sha256 "c02a6eb70a7a78efebe5adf3ade626eb75390e170bb8b3f36136a2c28f5326a0"
  end

  resource "egm08_25" do
    url "http://download.osgeo.org/proj/vdatum/egm08_25/egm08_25.gtx"
    sha256 "c18f20d1fe88616e3497a3eff993227371e1d9acc76f96253e8d84b475bbe6bf"
  end

  skip_clean :la

  def install
    resources.each do |r|
      if r.name == "datumgrid"
        (buildpath/"nad").install r
      elsif build.with? "vdatum"
        pkgshare.install r
      end
    end

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS
    assert_equal match,
                 `#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test`
  end
end
