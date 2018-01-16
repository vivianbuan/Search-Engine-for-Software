class Apel < Formula
  desc "Emacs Lisp library to help write portable Emacs programs"
  homepage "http://git.chise.org/elisp/apel/"
  url "http://git.chise.org/elisp/dist/apel/apel-10.8.tar.gz"
  sha256 "a511cc36bb51dc32b4915c9e03c67a994060b3156ceeab6fafa0be7874b9ccfe"

  bottle do
    cellar :any_skip_relocation
    sha256 "0886fb7b0cf5358b7354ccc81a7f95fff446c61b8dbf3bb3d66b8f322e455cee" => :high_sierra
    sha256 "f39010912a4a48b6dfce1b64e420bf3e3979a373a15a16dd5d5440c97c2d3a76" => :sierra
    sha256 "f47d90fd2aea06a0e52a75b84af03c7a97f479f00f621168eb5afb6f911e999f" => :el_capitan
    sha256 "90038f974eb80c5d670990f349a13d629e2139098720ca13b5a26c7c9a8c9360" => :yosemite
    sha256 "00acef6949043235fc8a613c1d5dc9f58d8e365bde486d42461fc89449ff834b" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}",
           "LISPDIR=#{elisp}", "VERSION_SPECIFIC_LISPDIR=#{elisp}"
  end

  test do
    program = testpath/"test-apel.el"
    program.write <<~EOS
      (add-to-list 'load-path "#{elisp}/emu")
      (require 'poe)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{program}").strip
  end
end
