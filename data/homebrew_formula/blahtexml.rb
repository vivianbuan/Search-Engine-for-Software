class Blahtexml < Formula
  desc "Converts equations into Math ML"
  homepage "http://gva.noekeon.org/blahtexml/"
  url "http://gva.noekeon.org/blahtexml/blahtexml-0.9-src.tar.gz"
  sha256 "c5145b02bdf03cd95b7b136de63286819e696639824961d7408bec4591bc3737"
  revision 1

  bottle do
    cellar :any
    sha256 "c2696cdaa1724541f0d07900219247365e30061a471df0b80f6469b3bc2b4a14" => :high_sierra
    sha256 "bcd628072b5b7d6625e2b2caad1c6f64483807facda1b2eff32795de1b25070f" => :sierra
    sha256 "b1788b8622b704c67b11295f6bf84ab881298980f8101b5fed6cb7441b4edc82" => :el_capitan
  end

  deprecated_option "blahtex-only" => "without-blahtexml"
  option "without-blahtexml", "Build only blahtex, not blahtexml"

  depends_on "xerces-c" if build.with? "blahtexml"
  needs :cxx11 if build.with? "blahtexml"

  # Add missing unistd.h includes, taken from MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-mainPng.cpp.diff"
    sha256 "7d4bce5630881099b71beedbbc09b64c61849513b4ac00197b349aab2eba1687"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0632225f/blahtexml/patch-main.cpp.diff"
    sha256 "d696d10931f2c2ded1cef50842b78887dba36679fbb2e0abc373e7b6405b8468"
  end

  def install
    ENV.cxx11 if build.with? "blahtexml"

    system "make", "blahtex-mac"
    bin.install "blahtex"
    if build.with? "blahtexml"
      system "make", "blahtexml-mac"
      bin.install "blahtexml"
    end
  end
end
