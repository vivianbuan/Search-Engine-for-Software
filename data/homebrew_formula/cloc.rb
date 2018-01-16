class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/1.74.tar.gz"
  sha256 "96af46fed0322d61f8bc61842a77d12bae42cd0bdf673495267e821d97ebcc68"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22c0c009a1db94a465bf2d78ff134739ad2e9815a261fbe2da227aadc299e09f" => :high_sierra
    sha256 "e7b47c2b072af1312ff8abf5fbefa0d43ce655a8bfa226aa2efac6133caac75e" => :sierra
    sha256 "7cfee2b95b9795d6ad016305c675101b1b78f5ca25afd6b2499bb52d74ca4a5b" => :el_capitan
    sha256 "3e2fb27f5b255286eb4be1af90c2fed48a5dc476cd51cc30c351d7d4abee664c" => :yosemite
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2016060801.tar.gz"
    sha256 "fc2fc178facf0292974d6511bad677dd038fe60d7ac118e3b83a1ca9e98a8403"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1903.tar.gz"
    sha256 "30e84ac4b31d40b66293f7b1221331c5a50561a39d580d85004d9c1fff991751"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # These are shipped as standard with OS X/macOS' default Perl, but
    # because upstream has chosen to use "#!/usr/bin/env perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec/"bin/cloc"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    man1.install libexec/"share/man/man1/cloc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
