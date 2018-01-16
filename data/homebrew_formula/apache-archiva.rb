class ApacheArchiva < Formula
  desc "The Build Artifact Repository Manager"
  homepage "https://archiva.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=archiva/2.2.3/binaries/apache-archiva-2.2.3-bin.tar.gz"
  sha256 "cf90d097e7c2763f6ff8df458b64be0348b35847de8b238c3e1e28e006da8bad"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]

    bin.install_symlink libexec/"bin/archiva"
  end

  def post_install
    (var/"archiva/logs").mkpath
    (var/"archiva/data").mkpath
    (var/"archiva/temp").mkpath

    cp_r libexec/"conf", var/"archiva"
  end

  plist_options :manual => "ARCHIVA_BASE=#{HOMEBREW_PREFIX}/var/archiva #{HOMEBREW_PREFIX}/opt/apache-archiva/bin/archiva console"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/archiva</string>
          <string>console</string>
        </array>
        <key>Disabled</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>archiva</string>
        <key>StandardOutPath</key>
        <string>#{var}/archiva/logs/launchd.log</string>
        <key>EnvironmentVariables</key>
        <dict>
          <key>ARCHIVA_BASE</key>
          <string>#{var}/archiva</string>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match "was not running.", shell_output("#{bin}/archiva stop")
  end
end
