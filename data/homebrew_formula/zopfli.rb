class Zopfli < Formula
  desc "New zlib (gzip, deflate) compatible compressor"
  homepage "https://github.com/google/zopfli"
  url "https://github.com/google/zopfli/archive/zopfli-1.0.1.tar.gz"
  sha256 "29743d727a4e0ecd1b93e0bf89476ceeb662e809ab2e6ab007a0b0344800e9b4"
  head "https://github.com/google/zopfli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52a345f7dc7df34ea5f13c0e91bfd4252964fe9f774b17a37c9ec33b94c1bcd1" => :high_sierra
    sha256 "5f99599ab4ec444d4eab8fda1dc408dbf66b7b2755500e2f77367690d25566db" => :sierra
    sha256 "c79a06778c3f97ea3480bba4f16ce15748d258674be2170423205163a56efed3" => :el_capitan
    sha256 "a1eee001d7ade7d9a6920b05e8a9f1ae834c32ef8b9ccd5b1e02e7b9e09fd5e5" => :yosemite
    sha256 "ae4f89b431c3f641385a66f61cab2e460b7217d0120b50da187b07dafb3a559c" => :mavericks
  end

  def install
    system "make", "zopfli", "zopflipng"
    bin.install "zopfli", "zopflipng"
  end

  test do
    system "#{bin}/zopfli"
    system "#{bin}/zopflipng", test_fixtures("test.png"), "#{testpath}/out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
