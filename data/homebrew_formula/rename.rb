class Rename < Formula
  desc "Perl-powered file rename script with many helpful built-ins"
  homepage "http://plasmasturm.org/code/rename"
  url "https://github.com/ap/rename/archive/v1.600.tar.gz"
  sha256 "538fa908c9c2c4e7a08899edb6ddb47f7cbeb9b1a1d04e003d3c19b56fcc7f88"

  head "https://github.com/ap/rename.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "131f754e5ea1245b32b79acca0f77ef5749973ed8326d5aac196a4c7f14efecf" => :high_sierra
    sha256 "9c92c253b431d5c821048a32309aebb2e7453e2121ae7661f7afcbd74479078c" => :sierra
    sha256 "29ee5c40a54dc5d1e7a157e28c19790120cd71ac5b072aa8bc1a07fdb4ad5dae" => :el_capitan
    sha256 "2ed1a6afa1543ca67c85763ac9cc23e40bb85d359234e2d4af0fe79db8439a89" => :yosemite
    sha256 "70f3263cbca5dbda0b477bf9838fdf4447c101ee89cd7f72fe2105657892431c" => :mavericks
    sha256 "c632dad8b0ddc1853db87eb88a408ee352a79a95a68f5574a0c2ba6512cf02ce" => :mountain_lion
  end

  def install
    system "pod2man", "rename", "rename.1"
    bin.install "rename"
    man1.install "rename.1"
  end

  test do
    touch "foo.doc"
    system "#{bin}/rename -s .doc .txt *.d*"
    refute_predicate testpath/"foo.doc", :exist?
    assert_predicate testpath/"foo.txt", :exist?
  end
end
