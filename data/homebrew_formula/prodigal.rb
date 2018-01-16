class Prodigal < Formula
  desc "Microbial gene prediction"
  homepage "https://github.com/hyattpd/Prodigal"
  url "https://github.com/hyattpd/Prodigal/archive/v2.6.3.tar.gz"
  sha256 "89094ad4bff5a8a8732d899f31cec350f5a4c27bcbdd12663f87c9d1f0ec599f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c120fed8e29bb3b1a4ff69d5ca05e051a0fe3822784b3d585e142da3452d1ac1" => :high_sierra
    sha256 "a27fe5316181d4826e5aa5291d0fc1b1a7087c32c7b4e6aedabf1209d5a8ac36" => :sierra
    sha256 "70b432e3d3da1f4089680b06c0745b7dac3611f05d8ec9440faa918bc82d6fe5" => :el_capitan
  end

  def install
    system "make", "install", "INSTALLDIR=#{bin}"
  end

  test do
    fasta = <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    assert_match "CDS", pipe_output("#{bin}/prodigal -q -p meta", fasta, 0)
  end
end
