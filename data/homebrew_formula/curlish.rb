class Curlish < Formula
  desc "Curl wrapper that adds support for OAuth 2.0"
  homepage "https://pythonhosted.org/curlish/"
  url "https://github.com/fireteam/curlish/archive/1.22.tar.gz"
  sha256 "6fdd406e6614b03b16be15b7b51568a7a041d2fb631be4e8caa223c0c3a28f00"

  head "https://github.com/fireteam/curlish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "913484a16fdeb402a8f1d0834401f9d9eeaf2d3fd38bfc9c96f4a3978050d9f0" => :high_sierra
    sha256 "ce2ef65c8c9f59f11b4edf7906af5504df8573e01ee7d6f6f996fc0647285433" => :sierra
    sha256 "5d97c4e9f5c4cd9246bc3be9e785fed094cb522c3110f1ca41408415875b08cc" => :el_capitan
    sha256 "6cd32ca680c05b00761eb422a067316d4bb172c171f3e4015da66ed319cec3d2" => :yosemite
    sha256 "f5a8b12596157c853a1f9179e4e47e9bc1259ab75e84efe61343e99bec6f62ab" => :mavericks
    sha256 "b01c4e78526de36f3b4e0fcac7ec049e2a4dd9366c8d32eae5692a3e626f99a4" => :mountain_lion
  end

  # curlish needs argparse (2.7+)
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    bin.install "curlish.py" => "curlish"
  end

  test do
    system "#{bin}/curlish", "https://brew.sh/"
  end
end
