class Rinetd < Formula
  desc "Internet TCP redirection server"
  homepage "https://www.boutell.com/rinetd/"
  url "https://www.boutell.com/rinetd/http/rinetd.tar.gz"
  version "0.62"
  sha256 "0c68d27c5bd4b16ce4f58a6db514dd6ff37b2604a88b02c1dfcdc00fc1059898"

  bottle do
    rebuild 1
    sha256 "44750b361b999c09a17a2bc8c576585a790c42bee66abe4df191b7b0cafe304c" => :high_sierra
    sha256 "7a52fc5d01d83fd186626a6cff981e65da8943186973a4314efa2c561480325e" => :sierra
    sha256 "30c72c1a5764aa20e7d8e232bcfe979f138e5029966c43468a886481304c39cb" => :el_capitan
  end

  def install
    inreplace "rinetd.c" do |s|
      s.gsub! "/etc/rinetd.conf", "#{etc}/rinetd.conf"
      s.gsub! "/var/run/rinetd.pid", "#{var}/rinetd.pid"
    end

    inreplace "Makefile" do |s|
      s.gsub! "/usr/sbin", sbin
      s.gsub! "/usr/man", man
    end

    sbin.mkpath
    man8.mkpath

    system "make", "install"

    conf = etc/"rinetd.conf"
    unless conf.exist?
      conf.write <<~EOS
        # forwarding rules go here
        #
        # you may specify allow and deny rules after a specific forwarding rule
        # to apply to only that forwarding rule
        #
        # bindadress bindport connectaddress connectport
      EOS
    end
  end

  test do
    system "#{sbin}/rinetd", "-h"
  end
end
