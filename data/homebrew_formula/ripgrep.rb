class Ripgrep < Formula
  desc "Search tool like grep and The Silver Searcher"
  homepage "https://github.com/BurntSushi/ripgrep"
  url "https://github.com/BurntSushi/ripgrep/archive/0.7.1.tar.gz"
  sha256 "e010693637acebb409f3dba7caf59ef093d1894a33b14015041b8d43547665f5"
  head "https://github.com/BurntSushi/ripgrep.git"

  bottle do
    sha256 "141f4a372665a161550835842cf967511cbad95487913fd28bb3fd87868c3755" => :high_sierra
    sha256 "5d41c5d4322357b2d39e00d24c37f4dec08fb3b4f2cd7d5dfd944627871646d4" => :sierra
    sha256 "8e183fb5763d350ae070756d3ff07e852ec624f6294d6657c067165328f7c6a5" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"

    bin.install "target/release/rg"
    man1.install "doc/rg.1"

    # Completion scripts are generated in the crate's build directory, which
    # includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/ripgrep-*/out"].first
    bash_completion.install "#{out_dir}/rg.bash-completion"
    fish_completion.install "#{out_dir}/rg.fish"
    zsh_completion.install "complete/_rg"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/rg", "Hello World!", testpath
  end
end
