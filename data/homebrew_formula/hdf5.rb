class Hdf5 < Formula
  desc "File format designed to store large amounts of data"
  homepage "https://www.hdfgroup.org/HDF5"
  url "https://www.hdfgroup.org/package/source-bzip2/?wpdmdl=4300"
  mirror "https://dl.bintray.com/homebrew/mirror/hdf5-1.10.1"
  version "1.10.1"
  sha256 "9c5ce1e33d2463fb1a42dd04daacbc22104e57676e2204e3d66b1ef54b88ebf2"
  revision 2

  bottle do
    rebuild 1
    sha256 "ce60d6ad246ecf8baae4e007a359da7c1cae8c3e199a2f9422f601fb0dc50e03" => :high_sierra
    sha256 "13fb989ccd1ce01a88be9159d15afd1898e7d358e7f338fec8542cef1204903c" => :sierra
    sha256 "fffbe4774667aa473e7ab6b004dea0247b98fab63ae7581b70ea129b6092c369" => :el_capitan
  end

  option "with-mpi", "Enable parallel support"

  deprecated_option "enable-parallel" => "with-mpi"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "szip"

  def install
    inreplace %w[c++/src/h5c++.in fortran/src/h5fc.in tools/src/misc/h5cc.in],
      "${libdir}/libhdf5.settings", "#{pkgshare}/libhdf5.settings"

    inreplace "src/Makefile.am", "settingsdir=$(libdir)", "settingsdir=#{pkgshare}"

    system "autoreconf", "-fiv"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
      --enable-build-mode=production
      --enable-fortran
    ]

    if build.without?("mpi")
      args << "--enable-cxx"
    else
      args << "--disable-cxx"
    end

    if build.with? "mpi"
      ENV["CC"] = "mpicc"
      ENV["CXX"] = "mpicxx"
      ENV["FC"] = "mpifc"

      args << "--enable-parallel"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "hdf5.h"
      int main()
      {
        printf("%d.%d.%d\\n", H5_VERS_MAJOR, H5_VERS_MINOR, H5_VERS_RELEASE);
        return 0;
      }
    EOS
    system "#{bin}/h5cc", "test.c"
    assert_equal version.to_s, shell_output("./a.out").chomp

    (testpath/"test.f90").write <<~EOS
      use hdf5
      integer(hid_t) :: f, dspace, dset
      integer(hsize_t), dimension(2) :: dims = [2, 2]
      integer :: error = 0, major, minor, rel

      call h5open_f (error)
      if (error /= 0) call abort
      call h5fcreate_f ("test.h5", H5F_ACC_TRUNC_F, f, error)
      if (error /= 0) call abort
      call h5screate_simple_f (2, dims, dspace, error)
      if (error /= 0) call abort
      call h5dcreate_f (f, "data", H5T_NATIVE_INTEGER, dspace, dset, error)
      if (error /= 0) call abort
      call h5dclose_f (dset, error)
      if (error /= 0) call abort
      call h5sclose_f (dspace, error)
      if (error /= 0) call abort
      call h5fclose_f (f, error)
      if (error /= 0) call abort
      call h5close_f (error)
      if (error /= 0) call abort
      CALL h5get_libversion_f (major, minor, rel, error)
      if (error /= 0) call abort
      write (*,"(I0,'.',I0,'.',I0)") major, minor, rel
      end
      EOS
    system "#{bin}/h5fc", "test.f90"
    assert_equal version.to_s, shell_output("./a.out").chomp
  end
end
