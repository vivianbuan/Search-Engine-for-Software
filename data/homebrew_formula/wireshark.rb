class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-2.4.4.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/wireshark-2.4.4.tar.xz"
  sha256 "049a758e39422dcd536d7f75cebbfaa44e4f305d602bf22964d6459821126f58"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "b77e69a3acc6a92d1658aa19679ece185b8552f17949379476dfcd1b4b91d2b6" => :high_sierra
    sha256 "84792750abb4894d11f75a04a1d683a6c4acdf0a713d6eba3b41324108b78450" => :sierra
    sha256 "15a09f0360d8a3cb5b3b8d140a4b28584e0cf542a4426a88c0d161ff0731395c" => :el_capitan
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-gtk+3", "Build the wireshark command with gtk+3"
  option "with-gtk+", "Build the wireshark command with gtk+"
  option "with-qt", "Build the wireshark command with Qt (can be used with or without either GTK option)"
  option "with-headers", "Install Wireshark library headers for plug-in development"
  option "with-nghttp2", "Enable HTTP/2 header dissection"

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "geoip"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "libsmi" => :optional
  depends_on "libssh" => :optional
  depends_on "nghttp2" => :optional
  depends_on "portaudio" => :optional
  depends_on "qt" => :optional
  depends_on "gtk+3" => :optional
  depends_on "gtk+" => :optional
  depends_on "adwaita-icon-theme" if build.with? "gtk+3"

  def install
    args = std_cmake_args + %w[
      -DENABLE_CARES=ON
      -DENABLE_GEOIP=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_LUA=ON
    ]

    if build.with? "qt"
      args << "-DBUILD_wireshark=ON"
      args << "-DENABLE_APPLICATION_BUNDLE=ON"
      args << "-DENABLE_QT5=ON"
    else
      args << "-DBUILD_wireshark=OFF"
      args << "-DENABLE_APPLICATION_BUNDLE=OFF"
      args << "-DENABLE_QT5=OFF"
    end

    if build.with?("gtk+3") || build.with?("gtk+")
      args << "-DBUILD_wireshark_gtk=ON"
      args << "-DENABLE_GTK3=" + (build.with?("gtk+3") ? "ON" : "OFF")
      args << "-DENABLE_PORTAUDIO=ON" if build.with? "portaudio"
    else
      args << "-DBUILD_wireshark_gtk=OFF"
      args << "-DENABLE_PORTAUDIO=OFF"
    end

    if build.with? "libsmi"
      args << "-DENABLE_SMI=ON"
    else
      args << "-DENABLE_SMI=OFF"
    end

    if build.with? "libssh"
      args << "-DBUILD_sshdump=ON" << "-DBUILD_ciscodump=ON"
    else
      args << "-DBUILD_sshdump=OFF" << "-DBUILD_ciscodump=OFF"
    end

    if build.with? "nghttp2"
      args << "-DENABLE_NGHTTP2=ON"
    else
      args << "-DENABLE_NGHTTP2=OFF"
    end

    system "cmake", *args
    system "make", "install"

    if build.with? "qt"
      prefix.install bin/"Wireshark.app"
      bin.install_symlink prefix/"Wireshark.app/Contents/MacOS/Wireshark" => "wireshark"
    end

    if build.with? "headers"
      (include/"wireshark").install Dir["*.h"]
      (include/"wireshark/epan").install Dir["epan/*.h"]
      (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
      (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
      (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
      (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
      (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
      (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
      (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
    end
  end

  def caveats; <<~EOS
    This formula only installs the command-line utilities by default.

    Wireshark.app can be downloaded directly from the website:
      https://www.wireshark.org/

    Alternatively, install with Homebrew-Cask:
      brew cask install wireshark

    If your list of available capture interfaces is empty
    (default macOS behavior), install ChmodBPF:

      brew cask install wireshark-chmodbpf
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
