class TeensyLoaderCli < Formula
  desc "Command-line integration for Teensy USB development boards"
  homepage "https://www.pjrc.com/teensy/loader_cli.html"
  url "https://github.com/PaulStoffregen/teensy_loader_cli/archive/2.1.tar.gz"
  sha256 "5c36fe45b9a3a71ac38848b076cd692bf7ca8826a69941c249daac3a1d95e388"
  revision 1
  head "https://github.com/PaulStoffregen/teensy_loader_cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "006db48c98aa23a5694588169a2732bc21413f117e7082597168831e01edc20b" => :high_sierra
    sha256 "297e5ae2cebf5f5c52809e671ef5b9d224dd7c184695dde5cbb94c085f616669" => :sierra
    sha256 "b422db39f01dfd49b77d9be2aade4d769b00c3068cce6da5250e9948a21cbf3b" => :el_capitan
    sha256 "760b87b4455a716d5fd57a3a4d3e45ce7f4a67743a2364ecbd7ef791a456abcc" => :yosemite
  end

  depends_on "libusb-compat" => :optional

  def install
    ENV["OS"] = "MACOSX"

    if build.with? "libusb-compat"
      ENV["USE_LIBUSB"] = "YES"
    else
      ENV["SDK"] = MacOS.sdk_path || "/"
    end

    system "make"
    bin.install "teensy_loader_cli"
  end

  test do
    output = shell_output("#{bin}/teensy_loader_cli 2>&1", 1)
    assert_match /Filename must be specified/, output
  end
end
