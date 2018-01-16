class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "http://kernel.ubuntu.com/~cking/stress-ng/"
  url "http://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.09.09.tar.xz"
  sha256 "e993fddb1d990a0cdb23b2af6cf6c417a1c09e155ada7c558ad80eae8a5feed3"

  bottle do
    cellar :any_skip_relocation
    sha256 "539064de393f2540cf4d882884e3e05ade03ddf064081f57352671e3ac00a446" => :high_sierra
    sha256 "fe7e12cb0884e29cc200bdccc153325861412e62d99692bee07f9bfde5cfa06f" => :sierra
  end

  depends_on :macos => :sierra

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
