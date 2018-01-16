class Zsdx < Formula
  desc "Zelda Mystery of Solarus DX"
  homepage "http://www.solarus-games.org/games/zelda-mystery-of-solarus-dx/"
  url "https://github.com/christopho/zsdx/archive/zsdx-1.11.0.tar.gz"
  sha256 "05a5d220bbf2439c9da2e71cd9d104240878123fff5bc702e2405d6d0712f0dc"
  head "https://github.com/christopho/zsdx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0460af05acc1c8beeceb5a6058ac0ad2cb27f423d43a87fb45aaf5b737c49f7b" => :high_sierra
    sha256 "2787c78e1b24669a1befa354724f77b6a86abf2aade492fe211c296482855cf8" => :sierra
    sha256 "2a1132ca3dc96d98332d99e1a37b1d2f46206fdad88066f96fedcfbf796452b3" => :el_capitan
    sha256 "c9fd0e90a1cf311d30a3e5b961e15a2e8a5a2400b1d985fc4f8c4591cca051d4" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "solarus"

  def install
    system "cmake", ".", *std_cmake_args, "-DSOLARUS_INSTALL_DATADIR=#{share}"
    system "make", "install"
  end

  test do
    system Formula["solarus"].bin/"solarus-run", "-help"
    system "/usr/bin/unzip", pkgshare/"data.solarus"
  end
end
