class Avrdude < Formula
  desc "Atmel AVR MCU programmer"
  homepage "https://savannah.nongnu.org/projects/avrdude/"
  url "https://download.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/avrdude/avrdude-6.3.tar.gz"
  sha256 "0f9f731b6394ca7795b88359689a7fa1fba818c6e1d962513eb28da670e0a196"

  bottle do
    sha256 "cf4744484312894ba0feb9380fae6bf13967655db74bd24c52ccc30c7eacd26c" => :high_sierra
    sha256 "45c59c4d7821476baa9354c5d57254ee2e7a589f4928f4ecc68f55c93dd648c6" => :sierra
    sha256 "4e5318b6c2022a2c33f2cd7528c02a23599097227a390855b8ad5f0680c85dd3" => :el_capitan
    sha256 "5abc4587ae12d475dd95a1b94e1c3045c4c4a64037d7be3dc935ff3a41d0285c" => :yosemite
    sha256 "17916229c901c02efd79616a053fd6910a1e6c07c90027d868b43c5b536f86d5" => :mavericks
  end

  head do
    url "https://svn.savannah.nongnu.org/svn/avrdude/trunk/avrdude"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libusb-compat"
  depends_on "libftdi0"
  depends_on "libelf"
  depends_on "libhid" => :optional

  def install
    if build.head?
      inreplace "bootstrap", /libtoolize/, "glibtoolize"
      system "./bootstrap"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "avrdude done.  Thank you.",
      shell_output("#{bin}/avrdude -c jtag2 -p x16a4 2>&1", 1).strip
  end
end
