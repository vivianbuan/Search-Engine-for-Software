class Arm < Formula
  desc "Terminal status monitor for Tor"
  homepage "https://www.atagar.com/arm/"
  url "https://www.atagar.com/arm/resources/static/arm-1.4.5.0.tar.bz2"
  sha256 "fc0e771585dde3803873b4807578060f0556cf1cac6c38840a714ffada3b28fa"
  revision 1

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"arm"
  end

  def caveats; <<~EOS
    You'll need to enable the Tor Control Protocol in your torrc.
    See here for details: https://www.torproject.org/tor-manual.html.en

    To configure Arm, copy the sample configuration from
    #{opt_libexec}/armrc.sample
    to ~/.arm/armrc, adjusting as needed.
    EOS
  end
end
