class Sratoolkit < Formula
  desc "Data tools for INSDC Sequence Read Archive"
  homepage "https://github.com/ncbi/sra-tools"
  url "https://github.com/ncbi/sra-tools/archive/2.8.2-5.tar.gz"
  version "2.8.2-5"
  sha256 "15b41420d95a72de9e24dec53401cc10e435a17ee9c5eec45ef78fd078db544c"
  head "https://github.com/ncbi/sra-tools.git"

  bottle do
    cellar :any
    sha256 "dd18ab4cc9d449dbbe79d22c1ad196b596439f1efe8d0617d8c261d9b5c82f7b" => :high_sierra
    sha256 "114f14b37c07ed9ee179fd75f5d5093a73e35d5edc9b2923305af59a45033a4c" => :sierra
    sha256 "7d46ae4e277640e7bc956caa37a95b7f7e4decfc826ef6b42f870683972dc855" => :el_capitan
  end

  depends_on "hdf5"
  depends_on "libmagic"

  resource "ngs-sdk" do
    url "https://github.com/ncbi/ngs/archive/1.3.0.tar.gz"
    sha256 "803c650a6de5bb38231d9ced7587f3ab788b415cac04b0ef4152546b18713ef2"
  end

  resource "ncbi-vdb" do
    url "https://github.com/ncbi/ncbi-vdb/archive/2.8.2-2.tar.gz"
    version "2.8.2-2"
    sha256 "7866f7abf00e35faaa58eb3cdc14785e6d42bde515de4bb3388757eb0c8f3c95"
  end

  def install
    ngs_sdk_prefix = buildpath/"ngs-sdk-prefix"
    resource("ngs-sdk").stage do
      cd "ngs-sdk" do
        system "./configure",
          "--prefix=#{ngs_sdk_prefix}",
          "--build=#{buildpath}/ngs-sdk-build"
        system "make"
        system "make", "install"
      end
    end

    ncbi_vdb_source = buildpath/"ncbi-vdb-source"
    ncbi_vdb_build = buildpath/"ncbi-vdb-build"
    ncbi_vdb_source.install resource("ncbi-vdb")
    cd ncbi_vdb_source do
      system "./configure",
        "--prefix=#{buildpath/"ncbi-vdb-prefix"}",
        "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
        "--build=#{ncbi_vdb_build}"
      ENV.deparallelize { system "make" }
    end

    # Fix the error: ld: library not found for -lmagic-static
    # Upstream PR: https://github.com/ncbi/sra-tools/pull/105
    inreplace "tools/copycat/Makefile", "-smagic-static", "-smagic"

    system "./configure",
      "--prefix=#{prefix}",
      "--with-ngs-sdk-prefix=#{ngs_sdk_prefix}",
      "--with-ncbi-vdb-sources=#{ncbi_vdb_source}",
      "--with-ncbi-vdb-build=#{ncbi_vdb_build}",
      "--build=#{buildpath}/sra-tools-build"

    system "make", "install"

    # Remove non-executable files.
    rm_r [bin/"magic", bin/"ncbi"]
  end

  test do
    assert_match "Read 1 spots for SRR000001", shell_output("#{bin}/fastq-dump -N 1 -X 1 SRR000001")
    assert_match "@SRR000001.1 EM7LVYS02FOYNU length=284", File.read("SRR000001.fastq")
  end
end
