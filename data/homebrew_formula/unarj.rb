class Unarj < Formula
  desc "ARJ file archiver"
  homepage "http://www.arjsoftware.com/files.htm"
  url "http://pkgs.fedoraproject.org/repo/pkgs/unarj/unarj-2.65.tar.gz/c6fe45db1741f97155c7def322aa74aa/unarj-2.65.tar.gz"
  sha256 "d7dcc325160af6eb2956f5cb53a002edb2d833e4bb17846669f92ba0ce3f0264"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b7158daf585ed94c61106abb7cbfc956f1a918e4d185ffaa89c755b1c9deba6" => :high_sierra
    sha256 "44c4722b1e3d30d987bcbd9fc9ccd7015c54d087bedb7da030e50cc84d0a52e6" => :sierra
    sha256 "7bdcd771f852f59915623dae370c8f807cbf20f242dad60d62afa1dc683cdf4a" => :el_capitan
    sha256 "95794638930505f1d4a23553571d62de07dd3f62da7687ef571c6f7e893bba42" => :yosemite
    sha256 "d81c8d0e7799847d65e8059eee61bb29f9e33ea3ea501465dee0cc7c68f425ff" => :mavericks
    sha256 "ec371113bda90ac0f08a58822a6131934f358a10c9bf2a7e09b066827bbe9c62" => :mountain_lion
  end

  resource "testfile" do
    url "https://s3.amazonaws.com/ARJ/ARJ286.EXE"
    sha256 "e7823fe46fd971fe57e34eef3105fa365ded1cc4cc8295ca3240500f95841c1f"
  end

  def install
    system "make"
    bin.mkdir
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    # Ensure that you can extract ARJ.EXE from a sample self-extracting file
    resource("testfile").stage do
      system "#{bin}/unarj", "e", "ARJ286.EXE"
      assert_predicate Pathname.pwd/"ARJ.EXE", :exist?
    end
  end
end
