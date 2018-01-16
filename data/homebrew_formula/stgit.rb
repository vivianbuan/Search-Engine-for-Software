class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://github.com/ctmarinas/stgit"
  url "https://github.com/ctmarinas/stgit/archive/v0.18.tar.gz"
  sha256 "00c83a0a057ee61a300f2291b8926f85521ffd1c92b4cb5152e2be3bf836d3a5"
  head "https://github.com/ctmarinas/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf5d28fd456e9d28a4dae935ce96968cfa019801381e9d4ba50ed978d42fe791" => :high_sierra
    sha256 "0eee6dda264e8d497079d734b3127dbc84931a831edcb488a6ea55f80cc1cce5" => :sierra
    sha256 "0eee6dda264e8d497079d734b3127dbc84931a831edcb488a6ea55f80cc1cce5" => :el_capitan
    sha256 "0eee6dda264e8d497079d734b3127dbc84931a831edcb488a6ea55f80cc1cce5" => :yosemite
  end

  def install
    ENV["PYTHON"] = "python" # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "log"
  end
end
