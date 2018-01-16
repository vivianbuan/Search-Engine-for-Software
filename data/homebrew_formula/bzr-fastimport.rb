class BzrFastimport < Formula
  desc "Bazaar plugin for fast loading of revision control"
  homepage "https://launchpad.net/bzr-fastimport"
  url "https://launchpad.net/bzr-fastimport/trunk/0.13.0/+download/bzr-fastimport-0.13.0.tar.gz"
  sha256 "5e296dc4ff8e9bf1b6447e81fef41e1217656b43368ee4056a1f024221e009eb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "af2955ee5a026c4573dbeb4be897babf2f8d3805636765b982b48793b8143c60" => :high_sierra
    sha256 "420a665897be0a5e807a396720e51cb722b8ead02effee281d5843d56e3881be" => :sierra
    sha256 "119240e135fcf0d170a009bd414b07fe13f65734afd5929de2527a62c66b6c79" => :el_capitan
    sha256 "1155531ccdff247dcf8ab9cae133263199cbd708a1ae6ddc4d6e68133d1ab712" => :yosemite
    sha256 "d784f0b66db2e31f53f7b21fa5263c3d050b490a45684d0f206c9488ca0335a6" => :mavericks
    sha256 "fab457013d0f24e2d88b2dd76ad72d6b0101b9356e231bb0255b71866d318259" => :mountain_lion
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "bazaar"

  resource "python-fastimport" do
    url "https://launchpad.net/python-fastimport/trunk/0.9.2/+download/python-fastimport-0.9.2.tar.gz"
    sha256 "fd60f1173e64a5da7c5d783f17402f795721b7548ea3a75e29c39d89a60f261e"
  end

  def install
    resource("python-fastimport").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    (share/"bazaar/plugins/fastimport").install Dir["*"]
  end

  def caveats; <<~EOS
    In order to use this plugin you must set your PYTHONPATH in your #{shell_profile}:

      export PYTHONPATH="#{opt_libexec}/vendor/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    bzr = Formula["bazaar"].bin/"bzr"
    system bzr, "init"
    assert_match(/fastimport #{version}/,
                 shell_output("#{bzr} plugins --verbose"))
    system bzr, "fast-export", "--plain", "."
  end
end
