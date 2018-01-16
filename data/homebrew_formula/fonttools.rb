class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.21.2/fonttools-3.21.2.zip"
  sha256 "96b636793c806206b1925e21224f4ab2ce5bea8ae0990ed181b8ac8d30848f47"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b442df81be2116971ab68015b73df4db12084e8c5847024c4de45b549abd9680" => :high_sierra
    sha256 "62b11fa5dd51c4aa8e94be0bdf866065f34c987c8b3171c6e3613fb7440c26ee" => :sierra
    sha256 "709484897698914e051a22d827f201b9be8a8ffff48e178d7f1356638785f948" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
