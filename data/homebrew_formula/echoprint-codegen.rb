class EchoprintCodegen < Formula
  desc "Codegen for Echoprint"
  homepage "https://github.com/spotify/echoprint-codegen"
  url "https://github.com/echonest/echoprint-codegen/archive/v4.12.tar.gz"
  sha256 "dc80133839195838975757c5f6cada01d8e09d0aac622a8a4aa23755a5a9ae6d"
  revision 2
  head "https://github.com/echonest/echoprint-codegen.git"

  bottle do
    cellar :any
    sha256 "6ba809491d295b1aa6e5d5d01c4798644c8e111dd28a915154a08b7a527ebedd" => :sierra
    sha256 "047111c6a160f827a000aa4184f78d579b7fb8ecbb13db6b11d3a6f79c243783" => :el_capitan
    sha256 "2de00aaf98a53d77f0d3d4b0af5e8457a2fdb708769524c60c8fea94d0b5f7cc" => :yosemite
    sha256 "7dfecc154ab9c57918073f46095484616e049ed365b95015432e2416bc425bea" => :mavericks
  end

  depends_on "ffmpeg"
  depends_on "taglib"
  depends_on "boost"

  # Removes unnecessary -framework vecLib; can be removed in the next release
  patch do
    url "https://github.com/echonest/echoprint-codegen/commit/5ac72c40ae920f507f3f4da8b8875533bccf5e02.diff?full_index=1"
    sha256 "713bffc8a02e2f53c7a0479f7efb6df732346f20cb055a4fda67da043bcf1c12"
  end

  def install
    system "make", "-C", "src", "install", "PREFIX=#{prefix}"
  end
end
