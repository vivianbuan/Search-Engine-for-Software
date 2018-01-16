class Nsq < Formula
  desc "Realtime distributed messaging platform"
  homepage "http://nsq.io"
  url "https://github.com/nsqio/nsq/archive/v1.0.0-compat.tar.gz"
  version "1.0.0"
  sha256 "c279d339eceb84cad09e2c2bc21e069e37988d0f6b7343d77238374081c9fd29"
  revision 1
  head "https://github.com/nsqio/nsq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf7029656b4cf5fbefaa252ed1cac50dc49a31139eda7b583165bfcacaec1e42" => :high_sierra
    sha256 "5bb322677d0bbb1f4f5fa7be1584cafbfcec01e67c0063f6ee14a13933389c6e" => :sierra
    sha256 "2f04a20ef5c05ddd00893198ca5134a455869d1a231893d7931603c60a4dd497" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "gpm" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nsqio"
    ln_s buildpath, "src/github.com/nsqio/nsq"
    system "gpm", "install"
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  def post_install
    (var/"log").mkpath
    (var/"nsq").mkpath
  end

  plist_options :manual => "nsqd -data-path=#{HOMEBREW_PREFIX}/var/nsq"

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
        <string>#{bin}/nsqd</string>
        <string>-data-path=#{var}/nsq</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/nsq</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/nsqd.error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/nsqd.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    begin
      lookupd = fork do
        exec bin/"nsqlookupd"
      end
      sleep 2
      d = fork do
        exec bin/"nsqd", "--lookupd-tcp-address=127.0.0.1:4160"
      end
      sleep 2
      admin = fork do
        exec bin/"nsqadmin", "--lookupd-http-address=127.0.0.1:4161"
      end
      sleep 2
      to_file = fork do
        exec bin/"nsq_to_file", "--lookupd-http-address=127.0.0.1:4161",
                                "--output-dir=#{testpath}",
                                "--topic=test"
      end
      sleep 2
      system "curl", "-d", "hello", "http://127.0.0.1:4151/pub?topic=test"
      sleep 2
      dat = File.read(Dir["*.dat"].first)
      assert_match "test", dat
      assert_match version.to_s, dat
    ensure
      Process.kill(9, lookupd)
      Process.kill(9, d)
      Process.kill(9, admin)
      Process.kill(9, to_file)
      Process.wait lookupd
      Process.wait d
      Process.wait admin
      Process.wait to_file
    end
  end
end
