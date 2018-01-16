class Dnstwist < Formula
  desc "Test domains for typo squatting, phishing and corporate espionage"
  homepage "https://github.com/elceef/dnstwist"
  url "https://github.com/elceef/dnstwist/archive/v1.02.tar.gz"
  sha256 "f53bc7e8676c2e89f26ef76faefcdd2a7de1c4b18601a5db1710f37e63d856d7"

  bottle do
    cellar :any
    sha256 "0b0b3cdb216228cf3b666f393b9f3964906486d4e77e6ded8ea1f8ef11301525" => :high_sierra
    sha256 "c64ccf688eca59bad28d3df047cb987ad4911416be945e33cba9d0b5e68f0131" => :sierra
    sha256 "c4a4ede766163bf4dc8acc41f968198b574f6527d687a547ece0c227845488c1" => :el_capitan
    sha256 "6ec5b4eded505da0cbc5a37ea12c720293510ba5f05f12a2e0067d4257bbb8c5" => :yosemite
    sha256 "22426190a5dad132035572a609f3f612716837b050f7ec68707bd5aee87b7418" => :mavericks
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "ssdeep"
  depends_on "geoip"

  resource "dnspython" do
    url "https://pypi.python.org/packages/source/d/dnspython/dnspython-1.12.0.zip"
    sha256 "63bd1fae61809eedb91f84b2185816fac1270ae51494fbdd36ea25f904a8502f"
  end

  resource "GeoIP" do
    url "https://pypi.python.org/packages/source/G/GeoIP/GeoIP-1.3.2.tar.gz"
    sha256 "a890da6a21574050692198f14b07aa4268a01371278dfc24f71cd9bc87ebf0e6"
  end

  resource "whois" do
    url "https://pypi.python.org/packages/source/w/whois/whois-0.7.tar.gz"
    sha256 "788ba4fa4986d06351c1572f63ef1576d26f3cd5ecf5d999934421540c87021c"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.8.0.tar.gz"
    sha256 "b2f003589b60924909c0acde472590c5ea83906986a7a25b6f7929eb20923b7b"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.3.0.tar.gz"
    sha256 "9daa53aff0b5cf64c85c10eab7ce6776880d0ee71b78cedeae196ae82b6734e9"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "ssdeep" do
    url "https://pypi.python.org/packages/source/s/ssdeep/ssdeep-3.1.1.tar.gz"
    sha256 "a6c66309e6b540d5c8ba08c018675dabaef2172f2cc6f6351b67395ba7bf2ddd"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    bin.install "dnstwist.py" => "dnstwist"
    (libexec/"bin/database").install "database/GeoIP.dat", "database/effective_tld_names.dat"
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    output = shell_output("#{bin}/dnstwist github.com")

    assert_match /#{version}/, output
    assert_match /Processing \d+ domain variants/, output
  end
end
