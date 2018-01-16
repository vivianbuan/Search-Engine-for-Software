class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.12.tar.gz"
  sha256 "cf8511bd283fe9fdc7fdf493706e9f8b4902f27b9d51e6a6dc601e16472cd129"

  bottle do
    cellar :any_skip_relocation
    sha256 "54a6761f3ce9942a371cbb0a946e437b91a9e85f8e2d2c883786dab17df5bbb6" => :high_sierra
    sha256 "8905b12ce358fa01a303182323f67f84b773199c6c7e2253354969f46931ae5b" => :sierra
    sha256 "80a40487ecd7a8d71531e01a95a4063909ee02bbf5d36f5992314b7a300ecd06" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
