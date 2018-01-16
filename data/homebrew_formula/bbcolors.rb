class Bbcolors < Formula
  desc "Save and load color schemes for BBEdit and TextWrangler"
  homepage "https://daringfireball.net/projects/bbcolors/"
  url "https://daringfireball.net/projects/downloads/bbcolors_1.0.1.zip"
  sha256 "6ea07b365af1eb5f7fb9e68e4648eec24a1ee32157eb8c4a51370597308ba085"

  bottle do
    cellar :any_skip_relocation
    sha256 "b54a89cbcfcb6a0fb0b3c1279884f1fa54196e2c22a19424ea95827f419030d9" => :high_sierra
    sha256 "cdc81c86b829ba9e051d693bccdb821ed78a8dc3a5df644fc156bfcd700d5686" => :sierra
    sha256 "2a713dae009e44685d1ef02b01d5202a24087129dab70366d2e30800b7dfb9cb" => :el_capitan
    sha256 "506d7f82fa38e1f694550be30a29554b8ecc8b303d47e9bb4fcadfc534ac55c7" => :yosemite
    sha256 "68b63b5913be9e20b8ebc726c5272e030f7572aeb6baab709a70725f632c69b1" => :mavericks
    sha256 "11e30dcfb7923267a89c670b8e919b6b6f38724f5c467e3b5f62ceb2b20d3799" => :mountain_lion
  end

  def install
    bin.install "bbcolors"
  end

  test do
    (testpath/"Library/Application Support/BBColors").mkpath
    system "#{bin}/bbcolors", "-list"
  end
end
