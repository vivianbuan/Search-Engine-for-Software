class Waon < Formula
  desc "Wave-to-notes transcriber"
  homepage "https://kichiki.github.io/WaoN/"
  url "https://github.com/kichiki/WaoN/archive/v0.11.tar.gz"
  sha256 "75d5c1721632afee55a54bcbba1a444e53b03f4224b03da29317e98aa223c30b"

  bottle do
    cellar :any
    sha256 "5c3c49f0740bfcf9d34fd9468af3d9caa8f19c53ee1d25f8d69442d63859c9ab" => :high_sierra
    sha256 "d7fd9859544bf3ccb739942f0db00928469356f4d82ab7848cdba2ae5c5e99e9" => :sierra
    sha256 "6f09559eaf287022f280991b44b5f4e86435fafda167c97a78239602183a3758" => :el_capitan
    sha256 "a16c4df918f59a71396d7c4a5806bafe4bda4a89d3aeb2a52d8dfd41ce6c0432" => :yosemite
    sha256 "7469ec9aa8f549c1294ddb362f8ec2473466c5b027007f3c14fb49984353d813" => :mavericks
    sha256 "bccba5b437852618f1d67fb521dfc2684bb4d70461c61966e97cdd286be40842" => :mountain_lion
  end

  depends_on "fftw"
  depends_on "libsndfile"
  depends_on "pkg-config" => :build

  def install
    system "make", "-f", "Makefile.waon", "waon"
    bin.install "waon"
    man1.install "waon.1"
  end

  test do
    system "say", "check one two", "-o", testpath/"test.aiff"
    system "#{bin}/waon", "-i", testpath/"test.aiff", "-o", testpath/"output.midi"
    assert_predicate testpath/"output.midi", :exist?
  end
end
