class CodesignRequirement < Requirement
  fatal true

  satisfy(:build_env => false) do
    FileUtils.mktemp do
      FileUtils.cp "/usr/bin/false", "llvm_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "lldb_codesign", "--dryrun", "llvm_check"
    end
  end

  def message
    <<~EOS
      lldb_codesign identity must be available to build with LLDB.
      See: https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt
    EOS
  end
end

class LlvmAT39 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  revision 1

  stable do
    url "https://releases.llvm.org/3.9.1/llvm-3.9.1.src.tar.xz"
    sha256 "1fd90354b9cf19232e8f168faf2220e79be555df3aa743242700879e8fd329ee"

    resource "clang" do
      url "https://releases.llvm.org/3.9.1/cfe-3.9.1.src.tar.xz"
      sha256 "e6c4cebb96dee827fa0470af313dff265af391cb6da8d429842ef208c8f25e63"
    end

    resource "clang-extra-tools" do
      url "https://releases.llvm.org/3.9.1/clang-tools-extra-3.9.1.src.tar.xz"
      sha256 "29a5b65bdeff7767782d4427c7c64d54c3a8684bc6b217b74a70e575e4813635"
    end

    resource "compiler-rt" do
      url "https://releases.llvm.org/3.9.1/compiler-rt-3.9.1.src.tar.xz"
      sha256 "d30967b1a5fa51a2503474aacc913e69fd05ae862d37bf310088955bdb13ec99"
    end

    # Only required to build & run Compiler-RT tests on macOS, optional otherwise.
    # https://clang.llvm.org/get_started.html
    resource "libcxx" do
      url "https://releases.llvm.org/3.9.1/libcxx-3.9.1.src.tar.xz"
      sha256 "25e615e428f60e651ed09ffd79e563864e3f4bc69a9e93ee41505c419d1a7461"
    end

    resource "libunwind" do
      url "https://releases.llvm.org/3.9.1/libunwind-3.9.1.src.tar.xz"
      sha256 "0b0bc73264d7ab77d384f8a7498729e3c4da8ffee00e1c85ad02a2f85e91f0e6"
    end

    resource "lld" do
      url "https://releases.llvm.org/3.9.1/lld-3.9.1.src.tar.xz"
      sha256 "48e128fabb2ddaee64ecb8935f7ac315b6e68106bc48aeaf655d179c65d87f34"
    end

    resource "lldb" do
      url "https://releases.llvm.org/3.9.1/lldb-3.9.1.src.tar.xz"
      sha256 "7e3311b2a1f80f4d3426e09f9459d079cab4d698258667e50a46dccbaaa460fc"
    end

    resource "openmp" do
      url "https://releases.llvm.org/3.9.1/openmp-3.9.1.src.tar.xz"
      sha256 "d23b324e422c0d5f3d64bae5f550ff1132c37a070e43c7ca93991676c86c7766"
    end

    resource "polly" do
      url "https://releases.llvm.org/3.9.1/polly-3.9.1.src.tar.xz"
      sha256 "9ba5e61fc7bf8c7435f64e2629e0810c9b1d1b03aa5b5605b780d0e177b4cb46"
    end
  end

  bottle do
    cellar :any
    sha256 "82fcabcbc4e8594bba74a511c0f127f7b8187e5452e0cd77d6e6fc2f008f1b1c" => :high_sierra
    sha256 "6349b9f0e6202230c159a3b08ca835931b922589e328b5f7fc850ac651c3eff6" => :sierra
    sha256 "227667c28cb291529dba440a43cc19504ef621ffd1990303f0d7f2b4a9978e67" => :el_capitan
    sha256 "aed4411921127ddfc377c4203dc2a4f313d56103a79126be83a9b954d1cb8223" => :yosemite
  end

  head do
    url "https://llvm.org/git/llvm.git", :branch => "release_39"

    resource "clang" do
      url "https://llvm.org/git/clang.git", :branch => "release_39"
    end

    resource "clang-extra-tools" do
      url "https://llvm.org/git/clang-tools-extra.git", :branch => "release_39"
    end

    resource "compiler-rt" do
      url "https://llvm.org/git/compiler-rt.git", :branch => "release_39"
    end

    resource "libcxx" do
      url "https://llvm.org/git/libcxx.git", :branch => "release_39"
    end

    resource "libunwind" do
      url "https://llvm.org/git/libunwind.git", :branch => "release_39"
    end

    resource "lld" do
      url "https://llvm.org/git/lld.git", :branch => "release_39"
    end

    resource "lldb" do
      url "https://llvm.org/git/lldb.git", :branch => "release_39"
    end

    resource "openmp" do
      url "https://llvm.org/git/openmp.git", :branch => "release_39"
    end

    resource "polly" do
      url "https://llvm.org/git/polly.git", :branch => "release_39"
    end
  end

  keg_only :versioned_formula

  option "without-compiler-rt", "Do not build Clang runtime support libraries for code sanitizers, builtins, and profiling"
  option "without-libcxx", "Do not build libc++ standard library"
  option "with-toolchain", "Build with Toolchain to facilitate overriding system compiler"
  option "with-lldb", "Build LLDB debugger"
  option "with-python", "Build bindings against custom Python"
  option "with-shared-libs", "Build shared instead of static libraries"
  option "without-libffi", "Do not use libffi to call external functions"

  depends_on "libffi" => :recommended # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "graphviz" => :optional # for the 'dot' tool (lldb)

  depends_on "ocaml" => :optional
  if build.with? "ocaml"
    depends_on "opam" => :build
    depends_on "pkg-config" => :build
  end

  if MacOS.version <= :snow_leopard
    depends_on "python"
  else
    depends_on "python" => :optional
  end
  depends_on "cmake" => :build

  if build.with? "lldb"
    depends_on "swig" if MacOS.version >= :lion
    depends_on CodesignRequirement
  end

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def build_libcxx?
    build.with?("libcxx") || !MacOS::CLT.installed?
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx") if build_libcxx?
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/polly").install resource("polly")

    if build.with? "lldb"
      if build.with? "python"
        pyhome = `python-config --prefix`.chomp
        ENV["PYTHONHOME"] = pyhome
        pylib = "#{pyhome}/lib/libpython2.7.dylib"
        pyinclude = "#{pyhome}/include/python2.7"
      end
      (buildpath/"tools/lldb").install resource("lldb")

      # Building lldb requires a code signing certificate.
      # The instructions provided by llvm creates this certificate in the
      # user's login keychain. Unfortunately, the login keychain is not in
      # the search path in a superenv build. The following three lines add
      # the login keychain to ~/Library/Preferences/com.apple.security.plist,
      # which adds it to the superenv keychain search path.
      mkdir_p "#{ENV["HOME"]}/Library/Preferences"
      username = ENV["USER"]
      system "security", "list-keychains", "-d", "user", "-s", "/Users/#{username}/Library/Keychains/login.keychain"
    end

    if build.with? "compiler-rt"
      (buildpath/"projects/compiler-rt").install resource("compiler-rt")

      # compiler-rt has some iOS simulator features that require i386 symbols
      # I'm assuming the rest of clang needs support too for 32-bit compilation
      # to work correctly, but if not, perhaps universal binaries could be
      # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
      # can almost be treated as an entirely different build from llvm.
      ENV.permit_arch_flags
    end

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_INSTALL_UTILS=ON
      -DWITH_POLLY=ON
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_TARGETS_TO_BUILD=all
    ]
    args << "-DLIBOMP_ARCH=x86_64"
    args << "-DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON" if build.with? "compiler-rt"
    args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON" if build.with? "toolchain"

    if build.with? "shared-libs"
      args << "-DBUILD_SHARED_LIBS=ON"
      args << "-DLIBOMP_ENABLE_SHARED=ON"
    else
      args << "-DLLVM_BUILD_LLVM_DYLIB=ON"
    end

    args << "-DLLVM_ENABLE_LIBCXX=ON" if build_libcxx?

    if build.with?("lldb") && build.with?("python")
      args << "-DLLDB_RELOCATABLE_PYTHON=ON"
      args << "-DPYTHON_LIBRARY=#{pylib}"
      args << "-DPYTHON_INCLUDE_DIR=#{pyinclude}"
    end

    if build.with? "libffi"
      args << "-DLLVM_ENABLE_FFI=ON"
      args << "-DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include"
      args << "-DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}"
    end

    mktemp do
      if build.with? "ocaml"
        ENV["OPAMYES"] = "1"
        ENV["OPAMROOT"] = Pathname.pwd/"opamroot"
        (Pathname.pwd/"opamroot").mkpath
        system "opam", "init", "--no-setup"
        system "opam", "install", "ocamlfind", "ctypes"
        system "opam", "config", "exec", "--",
               "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      else
        system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
      end
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if build.with? "toolchain"
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang"
  end

  def caveats
    s = <<~EOS
      LLVM executables are installed in #{opt_bin}.
      Extra tools are installed in #{opt_pkgshare}.
    EOS

    if build_libcxx?
      s += <<~EOS
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
      EOS
    end

    s
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>

      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{version}/include",
                           "omptest.c", "-o", "omptest"
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>

      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing Command Line Tools
    if MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I/usr/include", # this is where CLT installs stdio.h
              "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if MacOS::Xcode.installed?
      libclangxc = Dir["#{MacOS::Xcode.toolchain_path}/usr/lib/clang/#{DevelopmentTools.clang_version}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    if build_libcxx?
      system "#{bin}/clang++", "-v", "-nostdinc",
              "-std=c++11", "-stdlib=libc++",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "-L#{lib}",
              "-Wl,-rpath,#{lib}", "test.cpp", "-o", "test"
      assert_includes MachO::Tools.dylibs("test"), "#{opt_lib}/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./test").chomp
    end
  end
end
