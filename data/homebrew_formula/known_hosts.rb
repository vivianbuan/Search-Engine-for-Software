class KnownHosts < Formula
  desc "Command-line manager for known hosts"
  homepage "https://github.com/markmcconachie/known_hosts"
  url "https://github.com/markmcconachie/known_hosts/archive/1.0.0.tar.gz"
  sha256 "80a080aa3850af927fd332e5616eaf82e6226d904c96c6949d6034deb397ac63"

  head "https://github.com/markmcconachie/known_hosts.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e823e73e385c7d11c19e02a0fad28751447a96332222fed825505b98e5c4003" => :high_sierra
    sha256 "729e8dc06654b9dae55b1f4ff15a40ee28de3642285f82deb2f67f08a031f9b2" => :sierra
    sha256 "b1f7982e9fb744226dcdf2be12467613ca97fa9a05f92673a4c785f6f445333c" => :el_capitan
    sha256 "be8ddf7bec2c25ee2de9f84db383b56e25e45825386e6726bedbda41824c9d6a" => :yosemite
    sha256 "826d0ac6e5b61f6fa5278710b0acda82f474d9e81c85b644815a5963a296938f" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/known_hosts", "version"
  end
end
