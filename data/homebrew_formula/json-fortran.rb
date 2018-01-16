class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://github.com/jacobwilliams/json-fortran/archive/6.1.0.tar.gz"
  sha256 "95afb978ada157a19aeb45fb234ed8f4abf2a76749d212d77a31972cc47b8b3e"
  revision 1
  head "https://github.com/jacobwilliams/json-fortran.git"

  bottle do
    cellar :any
    sha256 "3421989b35f3f93e05d9150a482ccca217ab74840844817d44ce7d182cfca5d1" => :high_sierra
    sha256 "48401b56deb1efde18b05fafef29b23eae1a8998fa975637407c5351d5ae2159" => :sierra
    sha256 "41068b91a80f1a451d83d5389210d8313b9391fde897a19f87884a5aea79dbda" => :el_capitan
  end

  option "with-unicode-support", "Build json-fortran to support unicode text in json objects and files"
  option "without-docs", "Do not build and install FORD generated documentation for json-fortran"

  deprecated_option "without-robodoc" => "without-docs"

  depends_on "cmake" => :build
  depends_on "ford" => :build if build.with? "docs"
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE" # Use more GNU/Homebrew-like install layout
      args << "-DENABLE_UNICODE:BOOL=TRUE" if build.with? "unicode-support"
      args << "-DSKIP_DOC_GEN:BOOL=TRUE" if build.without? "docs"
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end
