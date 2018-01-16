class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8633fe113f7ec0351ee216e41bd56cc5e6c5b777212620c135e9e3f8f3cd3bbd" => :high_sierra
    sha256 "3603a67cae4501fcd0e610a9d40cf532fdc3a36b91de1da2a3931628c6f285eb" => :sierra
    sha256 "bc00f1a7c60564fed1ebf0ece40306aa169e4a7ddf7f9c8d56c7088130f5e530" => :el_capitan
    sha256 "8b33f44272b46174184639f3a6044f47151756039068343262d3e2cbe4a26a7c" => :yosemite
    sha256 "667650946f6e697657832f9f906f3a548bc55991e2422f8cbbbe7c793434111f" => :mavericks
    sha256 "a776ebf2d22d7b5fa492308fff20409696064ea70149c5cac695b75bcf004d7c" => :mountain_lion
  end

  option "without-python", "Build without python 2 support"

  depends_on "openssl"
  depends_on "python" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python3" => :optional

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/pull/14.patch?full_index=1"
    sha256 "ffc978cbc07521796c0738df77a3e40d79de0875156f9440ef63eca06b2e2779"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"

    Language::Python.each_python(build) do |python, _version|
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    output = `#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' \\
      -d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' \\
      -a '&waffle=liege' -k 14`
    assert_match /0e41270260895979317fff3898ab85668953aaa2/, output
    assert_match /&waffle=liege/, output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
