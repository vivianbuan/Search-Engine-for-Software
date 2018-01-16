class Grc < Formula
  desc "Colorize logfiles and command output"
  homepage "http://korpus.juls.savba.sk/~garabik/software/grc.html"
  url "https://github.com/garabik/grc/archive/v1.11.1.tar.gz"
  sha256 "9ae4bcc9186d6856e861d5b0e29b7b14db3f14e6b643e2df0076c104a94dbcba"
  revision 1
  head "https://github.com/garabik/grc.git"

  bottle :unneeded

  depends_on "python3"

  conflicts_with "cc65", :because => "both install `grc` binaries"

  def install
    # fix non-standard prefix installs
    inreplace ["grc", "grc.1"], "/etc", etc
    inreplace ["grcat", "grcat.1"], "/usr/local", HOMEBREW_PREFIX

    # so that the completions don't end up in etc/profile.d
    inreplace "install.sh",
      "mkdir -p $PROFILEDIR\ncp -fv grc.bashrc $PROFILEDIR", ""

    system "./install.sh", prefix, HOMEBREW_PREFIX
    etc.install "grc.bashrc"
    etc.install "grc.zsh"
    etc.install "grc.fish"
  end

  # Apply the upstream fix from garabik/grc@ddc789bf to preexisting config files
  def post_install
    grc_bashrc = etc/"grc.bashrc"
    bad = /^    alias ls='colourify ls --color'$/
    if grc_bashrc.exist? && File.read(grc_bashrc) =~ bad
      inreplace grc_bashrc, bad, "    alias ls='colourify ls'"
    end
  end

  def caveats; <<~EOS
    New shell sessions will use GRC if you add the relevant file to your profile e.g.:
      . #{etc}/grc.bashrc
    EOS
  end

  test do
    actual = pipe_output("#{bin}/grcat #{pkgshare}/conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end
