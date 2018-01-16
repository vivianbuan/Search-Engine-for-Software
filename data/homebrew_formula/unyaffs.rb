class Unyaffs < Formula
  desc "Extract files from a YAFFS2 filesystem image"
  homepage "https://github.com/ehlers/unyaffs"
  url "https://github.com/ehlers/unyaffs/archive/0.9.6.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/u/unyaffs/unyaffs_0.9.6.orig.tar.gz"
  sha256 "33c46419ab5cc5290f3b780f0cc9d93729962799f5eb7cecb9b352b85939fbbf"

  head "https://github.com/ehlers/unyaffs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aa75cab237e901fb971b36472e0e7dd99895647954f3df99ad95a159c2f9402" => :high_sierra
    sha256 "79cc4c6edc7c20887a6427cbcdd8c256849d61b47314888825d569863f9b44c1" => :sierra
    sha256 "e33a63724b42277e86a91f37261892c4bca734f8362307c94dbf1a0f410a59c1" => :el_capitan
    sha256 "484cdbf34b9a81e2e127115ed78b80efc0355efcaba53d6797dcc2c431f4bcf1" => :yosemite
    sha256 "b0b9f241a1d576c3ad54fe16e4e20d2b545622ea8b7b30b668672214ecc03591" => :mavericks
    sha256 "f4bf95fc8f6d31a8ffb94dd01e1152a82abc0301078865372f140d347a4ee623" => :mountain_lion
  end

  def install
    system "make"
    bin.install "unyaffs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unyaffs -V")
  end
end
