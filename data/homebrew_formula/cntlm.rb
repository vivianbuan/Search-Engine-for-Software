class Cntlm < Formula
  desc "NTLM authentication proxy with tunneling"
  homepage "https://cntlm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.bz2"
  sha256 "7b603d6200ab0b26034e9e200fab949cc0a8e5fdd4df2c80b8fc5b1c37e7b930"

  bottle do
    rebuild 1
    sha256 "97bf4da991ae873495d574675c4bca87dd184322ff6855818d19d6ef4eb28a0d" => :high_sierra
    sha256 "aee92f33d388d2c759c9ff881ebc1c9da35b2295d4050e489ebd72f48401a163" => :sierra
    sha256 "e41938ee125ee2ac25f72833b79f2c6326f421ac54f2bcf1ec46de6ebf59fa44" => :el_capitan
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "SYSCONFDIR=#{etc}"
    # install target fails - @adamv
    bin.install "cntlm"
    man1.install "doc/cntlm.1"
    etc.install "doc/cntlm.conf"
  end

  def caveats
    "Edit #{etc}/cntlm.conf to configure Cntlm"
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/cntlm</string>
          <string>-f</string>
        </array>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
