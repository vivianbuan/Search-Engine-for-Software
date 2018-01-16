class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automaticaly building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/20/1c/60fcdc15055ac42d220f7e0089f53937f44e615d6c33ae2c8ed98b9e5848/FoBiS.py-2.2.8.tar.gz"
  sha256 "e56aa3d75fb4b915a679a315fd8e8c19aa6f26332b9647cbbbf7f2103b6a5c8b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2d4192dd769121cba4317c8d49c340d40bcc3b2fa556593df072dfff073ba228" => :high_sierra
    sha256 "95af060c96e1516d0d969324a4bb2c74c6be548cfb553c1ba0adaae288ce65b5" => :sierra
    sha256 "6521158dc1a0753e06244ac05737ea495fbc81712306dec31bab8ead2cd41016" => :el_capitan
  end

  option "without-pygooglechart", "Disable support for coverage charts generated with pygooglechart"

  depends_on "gcc" # for gfortran
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "graphviz" => :recommended

  resource "pygooglechart" do
    url "https://files.pythonhosted.org/packages/95/88/54f91552de1e1b0085c02b96671acfba6e351915de3a12a398533fc82e20/pygooglechart-0.4.0.tar.gz"
    sha256 "018d4dd800eea8e0e42a4b3af2a3d5d6b2a2b39e366071b7f270e9628b5f6454"
  end

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/a9/a6/ee6721349489a2da6eedd3dba124f2b5ac15ee1e0a7bd4d3cfdc4fff0327/graphviz-0.8.1.zip"
    sha256 "6bffbec8b7a0619fe745515039d0d6bb41b6632f3dee02bcd2601581abc63f03"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install "pygooglechart" if build.with? "pygooglechart"
    venv.pip_install "graphviz" if build.with? "graphviz"
    venv.pip_install_and_link buildpath
  end

  test do
    (testpath/"test-mod.f90").write <<~EOS
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    EOS
    (testpath/"test-prog.f90").write <<~EOS
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    EOS
    system "#{bin}/FoBiS.py", "build", "-compiler", "gnu"
    assert_match /Hello FoBiS/, shell_output(testpath/"test-prog")
  end
end
