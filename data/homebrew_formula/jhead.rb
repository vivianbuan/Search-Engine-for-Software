class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "http://www.sentex.net/~mwandel/jhead/"
  url "http://www.sentex.net/~mwandel/jhead/jhead-3.00.tar.gz"
  sha256 "88cc01da018e242fe2e05db73f91b6288106858dd70f27506c4989a575d2895e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "91644d47cff25c954cba7ccaa0c243dcbde63e626e9e749571042952d8ab3337" => :high_sierra
    sha256 "1adb1ef54417bdf4bd235ab907e4c198508bc2cebadcb8602cdec7809bb9e3a6" => :sierra
    sha256 "6a15b6b97fae6971752afbd05aa07e94ccebf1b216c9e36a2ba7bbf6523482bc" => :el_capitan
    sha256 "b1d517e2de29ae9a906636f4ed18c99aa459b221d1bff65fc497f6e86eae53ba" => :yosemite
  end

  # Patch to provide a proper install target to the Makefile. The patch has
  # been submitted upstream through email. We need to carry this patch until
  # upstream decides to incorporate it.
  patch :DATA

  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/j/jhead/jhead_3.00-4.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/j/jhead/jhead_3.00-4.debian.tar.xz"
    sha256 "d2553bb7e7e47c33fa1136841e4b5bfbad6b92edce1dcad639ab5d74ace606aa"
    apply "patches/31_CVE-2016-3822"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end

__END__
--- a/makefile	2015-02-02 23:24:06.000000000 +0100
+++ b/makefile	2015-02-25 16:31:21.000000000 +0100
@@ -1,12 +1,18 @@
 #--------------------------------
 # jhead makefile for Unix
 #--------------------------------
+PREFIX=$(DESTDIR)/usr/local
+BINDIR=$(PREFIX)/bin
+DOCDIR=$(PREFIX)/share/doc/jhead
+MANDIR=$(PREFIX)/share/man/man1
 OBJ=.
 SRC=.
 CFLAGS:= $(CFLAGS) -O3 -Wall

 all: jhead

+docs = $(SRC)/usage.html
+
 objs = $(OBJ)/jhead.o $(OBJ)/jpgfile.o $(OBJ)/jpgqguess.o $(OBJ)/paths.o \
	$(OBJ)/exif.o $(OBJ)/iptc.o $(OBJ)/gpsinfo.o $(OBJ)/makernote.o

@@ -19,5 +25,8 @@
 clean:
	rm -f $(objs) jhead

-install:
-	cp jhead ${DESTDIR}/usr/local/bin/
+install: all
+	install -d $(BINDIR) $(DOCDIR) $(MANDIR)
+	install -m 0755 jhead $(BINDIR)
+	install -m 0644 $(docs) $(DOCDIR)
+	install -m 0644 jhead.1 $(MANDIR)
