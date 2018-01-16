class AflFuzz < Formula
  desc "American fuzzy lop: Security-oriented fuzzer"
  homepage "http://lcamtuf.coredump.cx/afl/"
  url "http://lcamtuf.coredump.cx/afl/releases/afl-2.52b.tgz"
  sha256 "43614b4b91c014d39ef086c5cc84ff5f068010c264c2c05bf199df60898ce045"

  bottle do
    sha256 "4cd6b08ecfe35a62136b7a52222c59e055b80aef599404e29c7c9b8bf4f8fd50" => :high_sierra
    sha256 "b45ff3036dddc75cf64689b3f2660938834f393256315ed33ba72ed1924c695e" => :sierra
    sha256 "ef5e7c2e25020bf2d468c81ced4fdd9014dbdc0bb523f5acd8d91d8badc97d59" => :el_capitan
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cpp_file = testpath/"main.cpp"
    cpp_file.write <<~EOS
      #include <iostream>

      int main() {
        std::cout << "Hello, world!";
      }
    EOS

    system bin/"afl-clang++", "-g", cpp_file, "-o", "test"
    assert_equal "Hello, world!", shell_output("./test")
  end
end
