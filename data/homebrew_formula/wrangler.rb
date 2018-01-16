class Wrangler < Formula
  desc "Refactoring tool for Erlang with emacs and Eclipse integration"
  homepage "https://www.cs.kent.ac.uk/projects/wrangler/Wrangler/"
  head "https://github.com/RefactoringTools/wrangler.git"

  stable do
    url "https://github.com/RefactoringTools/wrangler/archive/wrangler1.2.tar.gz"
    sha256 "a6a87ad0513b95bf208c660d112b77ae1951266b7b4b60d8a2a6da7159310b87"

    # upstream commit "Fix -spec's to compile in Erlang/OTP 19"
    patch do
      url "https://github.com/RefactoringTools/wrangler/commit/d81b888f.patch?full_index=1"
      sha256 "19f99f7ec8b70ec78ed59cbc0ba203d050ae09b7ed524d0ca06ad77d23564ba3"
    end
  end

  bottle do
    sha256 "8203501c2afc2e702b0b164bd750a8fe8ea16c4cb42032e08af265165c279f93" => :high_sierra
    sha256 "89663c4a49437fdd27f2446d829e1ef7c9ae4452280f8d087d71c3a89e5c319f" => :sierra
    sha256 "dfa0d430822b57df1c044ab395d347c81311346aaa102e4097e05c7c42f38b32" => :el_capitan
    sha256 "45df8699e1ba28596cfe6395a321b56213aa5cfd6545ea0a5bafcce39e9574dd" => :yosemite
    sha256 "6296e18bc0641ba1b20becdb16f4aabc500069999a2a23c487cd98d8309855c2" => :mavericks
  end

  depends_on "erlang"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    suffixtree = Dir.glob("#{lib}/erlang/*/*/*/suffixtree").shift
    assert_predicate Pathname.new(suffixtree), :executable?, "suffixtree must be executable"
  end
end
