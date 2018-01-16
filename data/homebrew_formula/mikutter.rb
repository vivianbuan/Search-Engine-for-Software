class Mikutter < Formula
  desc "Extensible Twitter client"
  homepage "https://mikutter.hachune.net/"
  url "https://mikutter.hachune.net/bin/mikutter.3.6.1.tar.gz"
  sha256 "852ebf397b07fd98db5ce8d12afce698ca96ff6cfb0f742ae2fd7417ec6dde89"
  head "git://toshia.dip.jp/mikutter.git", :branch => "develop"

  bottle do
    sha256 "ac7147b19e9f3dac50e95a2ee43abc965f5bad60d4964c7b315df1fc0ac5203d" => :high_sierra
    sha256 "244aeec203fe948056f30c46ce623ed6b0a39048f4198abca5ccfc1c88d92f5d" => :sierra
    sha256 "466308cd18d16b174a0a3f361ead753809afecc49a8596b5dc9a990529747e9e" => :el_capitan
  end

  depends_on "gtk+"
  depends_on "libidn"
  depends_on "ruby"
  depends_on "terminal-notifier" => :recommended

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.5.2.gem"
    sha256 "73771ea960b3900d96e6b3729bd203e66f387d0717df83304411bf37efd7386e"
  end

  resource "atk" do
    url "https://rubygems.org/gems/atk-3.2.0.gem"
    sha256 "94b3242581e2ee66cd15ca71b63ff169714a83551c7bbbb48d68b5fc5af71099"
  end

  resource "cairo" do
    url "https://rubygems.org/gems/cairo-1.15.11.gem"
    sha256 "de6cd85621ca7671967edbc4959b1f6c457d484448bdb71a0b837ba426480fb0"
  end

  resource "cairo-gobject" do
    url "https://rubygems.org/gems/cairo-gobject-3.2.0.gem"
    sha256 "02bb0999b9abee463425b3d86b811ef8db8fc74c042bed8c13a853b719d2f6be"
  end

  resource "crack" do
    url "https://rubygems.org/gems/crack-0.4.3.gem"
    sha256 "5318ba8cd9cf7e0b5feb38948048503ba4b1fdc1b6ff30a39f0a00feb6036b29"
  end

  resource "delayer" do
    url "https://rubygems.org/gems/delayer-0.0.2.gem"
    sha256 "39ece17be3e4528d562a88aef7cb25143ef4ce77df2925a7534f8a163af1db94"
  end

  resource "delayer-deferred" do
    url "https://rubygems.org/gems/delayer-deferred-2.0.0.gem"
    sha256 "bf135b0a76eb30223e447da7afe915726321716856acf5e0e3453efb3dbc787f"
  end

  resource "diva" do
    url "https://rubygems.org/gems/diva-0.3.1.gem"
    sha256 "a8b5151497db49a12778401e20fe3405596a7d3a6a888be98124ec016b20ef58"
  end

  resource "gdk_pixbuf2" do
    url "https://rubygems.org/gems/gdk_pixbuf2-3.2.0.gem"
    sha256 "835a5a28e81327ab03cf211dcbd70eefe85efd518f38da2f131066b63d443756"
  end

  resource "gettext" do
    url "https://rubygems.org/gems/gettext-3.0.9.gem"
    sha256 "390ee547437d62d00b859383d1af816cf06f0adee9ced1949f821b720d187c93"
  end

  resource "gio2" do
    url "https://rubygems.org/gems/gio2-3.2.0.gem"
    sha256 "c4177d5a7569d465d5009f74bfc514181d1d8e3fc6201d87325dca47464d2f12"
  end

  resource "glib2" do
    url "https://rubygems.org/gems/glib2-3.2.0.gem"
    sha256 "2ac7ba26ce9f282d4759867229ca837d9b823823826f1e7ecbf5b6a90eb2d04a"
  end

  resource "gobject-introspection" do
    url "https://rubygems.org/gems/gobject-introspection-3.2.0.gem"
    sha256 "5c39df3bd52c59867063edaee890d2dc5f0d1c186fd3a0e3c769bc114ed74042"
  end

  resource "gtk2" do
    url "https://rubygems.org/gems/gtk2-3.2.0.gem"
    sha256 "5b28c07550e3ccaf7a3595a62de7acfb33c407450fc193e28c6d04f68221ccd2"
  end

  resource "hashdiff" do
    url "https://rubygems.org/gems/hashdiff-0.3.7.gem"
    sha256 "e94a08689f724a571556b78d5ca35214033d3961972d58c4611245c4b3a0457a"
  end

  resource "httpclient" do
    url "https://rubygems.org/gems/httpclient-2.8.3.gem"
    sha256 "2951e4991214464c3e92107e46438527d23048e634f3aee91c719e0bdfaebda6"
  end

  resource "idn-ruby" do
    url "https://rubygems.org/gems/idn-ruby-0.1.0.gem"
    sha256 "99abba21c66e61fa16f2ddb2a507b4fd5a8d84ece77711f0d2e2bc313da36b1f"
  end

  resource "instance_storage" do
    url "https://rubygems.org/gems/instance_storage-1.0.0.gem"
    sha256 "f41e64da2fe4f5f7d6c8cf9809ef898e660870f39d4e5569c293b584a12bce22"
  end

  resource "json_pure" do
    url "https://rubygems.org/gems/json_pure-1.8.6.gem"
    sha256 "55d575c4aec98249473811a256b3f3a7c12a94ad008093032f5e5f28eacd94ee"
  end

  resource "locale" do
    url "https://rubygems.org/gems/locale-2.1.2.gem"
    sha256 "1db4a6b5f21fcd64f397d61bf2af69840dc11b3176d1fa6d75a0e749f04a9aea"
  end

  resource "memoist" do
    url "https://rubygems.org/gems/memoist-0.16.0.gem"
    sha256 "70bd755b48477c9ef9601daa44d298e04a13c1727f8f9d38c34570043174085f"
  end

  resource "metaclass" do
    url "https://rubygems.org/gems/metaclass-0.0.4.gem"
    sha256 "8569685c902108b1845be4e5794d646f2a8adcb0280d7651b600dab0844fe942"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.3.0.gem"
    sha256 "216417b241ff4e7b1c726f257241eaf223e3abbe6ec2c6453352dea6a414a38d"
  end

  resource "mocha" do
    url "https://rubygems.org/gems/mocha-0.14.0.gem"
    sha256 "4bb00fdc69d628b15ad2b89ca6f490aaf92486f640282b8943fe3b43dee9a145"
  end

  resource "moneta" do
    url "https://rubygems.org/gems/moneta-1.0.0.gem"
    sha256 "2224e5a68156e8eceb525fb0582c8c4e0f29f67cae86507cdcfb406abbb1fc5d"
  end

  resource "native-package-installer" do
    url "https://rubygems.org/gems/native-package-installer-1.0.6.gem"
    sha256 "7cff2ddbedc529e5f98422288e198428fcf420d78ffabfd4c88536870dda0c3f"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.8.1.gem"
    sha256 "4180dd5dfe8ba5479db7c3030012cd79da9b958eea472195f3daa23cbf80bd80"
  end

  resource "oauth" do
    url "https://rubygems.org/gems/oauth-0.5.4.gem"
    sha256 "3e017ed1c107eb6fe42c977b78c8a8409249869032b343cf2f23ac80d16b5fff"
  end

  resource "pango" do
    url "https://rubygems.org/gems/pango-3.2.0.gem"
    sha256 "cddd588da511debde6d65ab84beb40ca86d9ab98e596d1858787d8d6f4d90419"
  end

  resource "pkg-config" do
    url "https://rubygems.org/gems/pkg-config-1.2.9.gem"
    sha256 "8880747a35362493a48dd331a40f9dab2e0469fe74a0899bd3559f810046b8d8"
  end

  resource "pluggaloid" do
    url "https://rubygems.org/gems/pluggaloid-1.1.1.gem"
    sha256 "f9279fad38d0bf4e20ee70e30882c6cb7916bc764bf72b2f955f0ac0ff0a3a5d"
  end

  resource "power_assert" do
    url "https://rubygems.org/gems/power_assert-1.1.1.gem"
    sha256 "3f9221717f88faf246e1d7a59276bb44741f0c0b000974c65cd47aad280b1a40"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-3.0.1.gem"
    sha256 "67182699cb644e66b4c68d30b5f1dd42e3dfe6c0aa0d8fd36a1e71c97c6a7f57"
  end

  resource "rake" do
    url "https://rubygems.org/gems/rake-10.5.0.gem"
    sha256 "2b55a1ad44b5c945719d8a97c302a316af770b835187d12143e83069df5a8a49"
  end

  resource "ruby-hmac" do
    url "https://rubygems.org/gems/ruby-hmac-0.4.0.gem"
    sha256 "a4245ecf2cfb2036975b63dc37d41426727d8449617ff45daf0b3be402a9fe07"
  end

  resource "ruby-prof" do
    url "https://rubygems.org/gems/ruby-prof-0.17.0.gem"
    sha256 "4c3838e460d6af672861983c80dc0be6d6c41c24d9d0a04239a8851d03a4e40b"
  end

  resource "safe_yaml" do
    url "https://rubygems.org/gems/safe_yaml-1.0.4.gem"
    sha256 "248193992ef1730a0c9ec579999ef2256a2b3a32a9bd9d708a1e12544a489ec2"
  end

  resource "test-unit" do
    url "https://rubygems.org/gems/test-unit-3.2.7.gem"
    sha256 "106b62bae71176886451cf08bf5049a6e783553129ee9d20c92edaf664978f5b"
  end

  resource "text" do
    url "https://rubygems.org/gems/text-1.3.1.gem"
    sha256 "2fbbbc82c1ce79c4195b13018a87cbb00d762bda39241bb3cdc32792759dd3f4"
  end

  resource "totoridipjp" do
    url "https://rubygems.org/gems/totoridipjp-0.1.0.gem"
    sha256 "93d1245c5273971c855b506a7a913d23d6f524e9d7d4494127ae1bc6174c910d"
  end

  resource "twitter-text" do
    url "https://rubygems.org/gems/twitter-text-2.1.0.gem"
    sha256 "ca4ce1c4bc91c412d5b85c12e12d96aff2b347ca01656a0986981bcb4738fbc5"
  end

  resource "typed-array" do
    url "https://rubygems.org/gems/typed-array-0.1.2.gem"
    sha256 "891fa1de2cdccad5f9e03936569c3c15d413d8c6658e2edfe439d9386d169b62"
  end

  resource "unf" do
    url "https://rubygems.org/gems/unf-0.1.4.gem"
    sha256 "4999517a531f2a955750f8831941891f6158498ec9b6cb1c81ce89388e63022e"
  end

  resource "unf_ext" do
    url "https://rubygems.org/gems/unf_ext-0.0.7.4.gem"
    sha256 "8b3e34ddcc5db65c6e0c9f34b5bd62720e770ba04843d601c3730c887f131992"
  end

  resource "watch" do
    url "https://rubygems.org/gems/watch-0.1.0.gem"
    sha256 "1d3e767cb917f226cb970ac0e39c9ee613f9082a390598bf94be516bbd79e409"
  end

  resource "webmock" do
    url "https://rubygems.org/gems/webmock-1.24.6.gem"
    sha256 "c516e1b309697af303e647dc2f3c7222b13ef70c1c4c5afb61e64bd595c9740f"
  end

  def install
    (lib/"mikutter/vendor").mkpath
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system("gem", "install", r.cached_download, "--no-document",
             "--install-dir", "#{lib}/mikutter/vendor")
    end

    rm_rf "vendor"
    (lib/"mikutter").install "plugin"
    libexec.install Dir["*"]

    (bin/"mikutter").write(exec_script)
    pkgshare.install_symlink libexec/"core/skin"

    # enable other formulae to install plugins
    libexec.install_symlink HOMEBREW_PREFIX/"lib/mikutter/plugin"
  end

  def exec_script
    <<~EOS
      #!/bin/bash

      export DISABLE_BUNDLER_SETUP=1

      # also include gems/gtk modules from other formulae
      export GEM_HOME="#{HOMEBREW_PREFIX}/lib/mikutter/vendor"
      export GTK_PATH="#{HOMEBREW_PREFIX}/lib/gtk-2.0"

      exec ruby "#{libexec}/mikutter.rb" "$@"
    EOS
  end

  test do
    (testpath/".mikutter/plugin/test_plugin/test_plugin.rb").write <<~EOS
      # -*- coding: utf-8 -*-
      Plugin.create(:test_plugin) do
        require 'logger'

        Delayer.new do
          log = Logger.new(STDOUT)
          log.info("loaded test_plugin")
          exit
        end
      end

      # this is needed in order to boot mikutter >= 3.6.0
      class Post
        def self.primary_service
          nil
        end
      end
    EOS
    system bin/"mikutter", "plugin_depends",
           testpath/".mikutter/plugin/test_plugin/test_plugin.rb"
    system bin/"mikutter", "--plugin=test_plugin", "--debug"
  end
end
