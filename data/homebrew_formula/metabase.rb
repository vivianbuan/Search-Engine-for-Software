class Metabase < Formula
  desc "Business intelligence report server"
  homepage "https://www.metabase.com/"
  url "http://downloads.metabase.com/v0.27.2/metabase.jar"
  sha256 "27b2294ba5b2d6a250413662ec4019d120d3e63feb02ae8d5b524d61c6344df7"

  head do
    url "https://github.com/metabase/metabase.git"

    depends_on "node" => :build
    depends_on "yarn" => :build
    depends_on "leiningen" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    if build.head?
      system "./bin/build"
      libexec.install "target/uberjar/metabase.jar"
    else
      libexec.install "metabase.jar"
    end

    (bin/"metabase").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="$(#{Language::Java.java_home_cmd("1.8")})"
      exec java -jar "#{libexec}/metabase.jar" "$@"
    EOS
  end

  plist_options :startup => true, :manual => "metabase"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/metabase</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/metabase</string>
      <key>StandardOutPath</key>
      <string>#{var}/metabase/server.log</string>
      <key>StandardErrorPath</key>
      <string>/dev/null</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"metabase", "migrate", "up"
  end
end
