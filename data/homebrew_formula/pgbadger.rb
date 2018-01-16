class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://dalibo.github.io/pgbadger/"
  url "https://github.com/dalibo/pgbadger/archive/v9.2.tar.gz"
  sha256 "2107466309a409fb9e40f11bb77cac1f9ba7910d5328e7b2e08eb7a1c6d760ec"

  head "https://github.com/dalibo/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a481b5c37d9517b2329493447798188e722f354a4d0309dbecc505f1b0e9bbdf" => :high_sierra
    sha256 "d67b1d85810ffbcd8b638b44cbcce14744e6aff9f72f2e3085047897f3cad0d3" => :sierra
    sha256 "d67b1d85810ffbcd8b638b44cbcce14744e6aff9f72f2e3085047897f3cad0d3" => :el_capitan
    sha256 "d67b1d85810ffbcd8b638b44cbcce14744e6aff9f72f2e3085047897f3cad0d3" => :yosemite
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1p"
  end

  def caveats; <<~EOS
    You must configure your PostgreSQL server before using pgBadger.
    Edit postgresql.conf (in #{var}/postgres if you use Homebrew's
    PostgreSQL), set the following parameters, and restart PostgreSQL:

      log_destination = 'stderr'
      log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '
      log_statement = 'none'
      log_duration = off
      log_min_duration_statement = 0
      log_checkpoints = on
      log_connections = on
      log_disconnections = on
      log_lock_waits = on
      log_temp_files = 0
      lc_messages = 'C'
    EOS
  end

  test do
    (testpath/"server.log").write <<~EOS
      LOG:  autovacuum launcher started
      LOG:  database system is ready to accept connections
    EOS
    system bin/"pgbadger", "-f", "syslog", "server.log"
    assert_predicate testpath/"out.html", :exist?
  end
end
