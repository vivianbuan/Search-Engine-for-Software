class Dumb < Formula
  desc "IT, XM, S3M and MOD player library"
  homepage "https://dumb.sourceforge.io"
  url "https://downloads.sourceforge.net/project/dumb/dumb/0.9.3/dumb-0.9.3.tar.gz"
  sha256 "8d44fbc9e57f3bac9f761c3b12ce102d47d717f0dd846657fb988e0bb5d1ea33"

  bottle do
    cellar :any_skip_relocation
    sha256 "674db2be479a742057619122759da52683c74b724b3e318f2fc71a4fa6bd7287" => :high_sierra
    sha256 "04219fcc6bf6cd174cb5c2ddde4bfdbff266ed665e543c9948911e731d682dc9" => :sierra
    sha256 "d2352df11bee735e963b887609578ec1b3acf0e07748385f472a6add0e1cd2b6" => :el_capitan
    sha256 "317ac8139d8efb03022bb4f9a76ad61f2358570680563924d13229c52b282dff" => :yosemite
    sha256 "ee41051ed609807bfb8ce774fa614869db6bdd0fe9a307f6f2cb89f99e9db78e" => :mavericks
  end

  def install
    (buildpath/"make/config.txt").write <<~EOS
      include make/unix.inc
      ALL_TARGETS := core core-examples core-headers
      PREFIX := #{prefix}
    EOS
    bin.mkpath
    include.mkpath
    lib.mkpath
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage: dumb2wav", shell_output("#{bin}/dumb2wav 2>&1", 1)
  end
end
