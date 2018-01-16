class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  version_scheme 1
  head "https://github.com/premake/premake-core.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ad51fca2552a674929ec4d048fc05a88d24373673a701705e3b35c50a8611e" => :high_sierra
    sha256 "9e5d1dd706b3b3af1c8fc5cfe42141cf2a023185f9d19bb25dc58f8aced440e2" => :sierra
    sha256 "9e5d1dd706b3b3af1c8fc5cfe42141cf2a023185f9d19bb25dc58f8aced440e2" => :el_capitan
    sha256 "4b1ce1c63cc3ecca7e195d4c0350fb6f823f659c36ff6c1193fd99023ed25b12" => :yosemite
  end

  devel do
    url "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha12/premake-5.0.0-alpha12-src.zip"
    sha256 "5fa4a9f5b100024e23e2b9117ffa4935a6ac3c0a61aa027c3211388d53536751"
  end

  def install
    if build.head?
      system "make", "-f", "Bootstrap.mak", "osx"
      system "./premake5", "gmake"
    end

    system "make", "-C", "build/gmake.macosx"

    if build.devel? || build.head?
      bin.install "bin/release/premake5"
    else
      bin.install "bin/release/premake4"
    end
  end

  test do
    if stable?
      assert_match version.to_s, shell_output("#{bin}/premake4 --version", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/premake5 --version")
    end
  end
end
