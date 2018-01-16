class Speex < Formula
  desc "Audio codec designed for speech"
  homepage "https://speex.org/"
  url "https://downloads.xiph.org/releases/speex/speex-1.2.0.tar.gz"
  sha256 "eaae8af0ac742dc7d542c9439ac72f1f385ce838392dc849cae4536af9210094"

  bottle do
    cellar :any
    sha256 "525970161e7c1629b242c91d889201ca368814945695efd5b441d58b5b5dcc75" => :high_sierra
    sha256 "5aa61761fb5426de78297fdc83579515dda1a880f47c925cb3405b7175079b92" => :sierra
    sha256 "056781a4d7c5fe9a05f30160c059352bda0a4f8a759820df7dde7233aa08cba5" => :el_capitan
    sha256 "a0b3c91782b8242508adac3ebc0cd86688e75b043ea0d84f4ef7ac9940f8a21b" => :yosemite
  end

  option "with-sse", "Build with SSE support"

  depends_on "pkg-config" => :build
  depends_on "libogg" => :recommended
  depends_on "speexdsp" => :optional

  def install
    ENV.deparallelize
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]
    args << "--enable-sse" if build.with? "sse"
    system "./configure", *args
    system "make", "install"
  end
end
