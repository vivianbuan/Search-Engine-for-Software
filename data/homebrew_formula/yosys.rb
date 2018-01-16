class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/cliffordwolf/yosys/archive/yosys-0.7.tar.gz"
  sha256 "3df986d0c6bf20b78193456e11c660f2ad935cc126537c2dc5726e78896d6e6e"

  bottle do
    sha256 "baf2ef29983cbba7381d4d34721385b5308eeb1c9229c45b6bc6a2a98388b0e6" => :high_sierra
    sha256 "ff9af2558a3dfff5f5d08fc9bea6b649f01fcc65f96a293ad9abe57d410b96f3" => :sierra
    sha256 "d39cb5298e5d65e16a1a942dfeb4b6e81079b08c350dfa829fb2c57f80a2852c" => :el_capitan
    sha256 "7310d9d86c5480c69ebb32a0721245d82b3920ddab6f85ace8a3276b63dfee71" => :yosemite
  end

  depends_on "python3"
  depends_on "libffi" => :recommended
  depends_on "readline" => :recommended
  depends_on "pkg-config" => :build
  depends_on "bison" => :build

  # The makefile in Yosys 0.7 adds library search paths from macports, which a homebrew build
  # should not be using. It also prints warnings about a missing brew command.
  # See https://github.com/cliffordwolf/yosys/pull/303 for discussion.
  # The patch is based on the Makefile changes in this upstream commit:
  # https://github.com/cliffordwolf/yosys/commit/a431f4ee311b9563f546201d255e429e9ce58cfa
  patch :DATA

  # This ABC revision is specified in the makefile.
  # The makefile by default checks it out using mercurial,
  # but this recipe instead downloads a tar.gz archive.
  resource "abc" do
    url "https://bitbucket.org/alanmi/abc/get/eb6eca6807cc.tar.gz"
    sha256 "ae9acddad38a950d48466e2f66de8116f2d21d03c78f5a270fa3bf77c3fd7b5b"
  end

  def install
    args = []
    resource("abc").stage buildpath/"abc"
    args << "ENABLE_PLUGINS=0" if build.without? "libffi"
    args << "ENABLE_READLINE=0" if build.without? "readline"
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0", "ABCREV=default", *args
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 0a61fe65..2d973b18 100644
--- a/Makefile
+++ b/Makefile
@@ -53,23 +53,31 @@ CXXFLAGS += -Wall -Wextra -ggdb -I. -I"$(YOSYS_SRC)" -MD -D_YOSYS_ -fPIC -I$(PRE
 LDFLAGS += -L$(LIBDIR)
 LDLIBS = -lstdc++ -lm

-PKG_CONFIG = pkg-config
-SED = sed
-BISON = bison
+PKG_CONFIG ?= pkg-config
+SED ?= sed
+BISON ?= bison

 ifeq (Darwin,$(findstring Darwin,$(shell uname)))
-	# add macports/homebrew include and library path to search directories, don't use '-rdynamic' and '-lrt':
-	CXXFLAGS += -I/opt/local/include -I/usr/local/opt/readline/include
-	LDFLAGS += -L/opt/local/lib -L/usr/local/opt/readline/lib
-	# add homebrew's libffi include and library path
-	CXXFLAGS += $(shell PKG_CONFIG_PATH=$$(brew list libffi | grep pkgconfig | xargs dirname) pkg-config --silence-errors --cflags libffi)
-	LDFLAGS += $(shell PKG_CONFIG_PATH=$$(brew list libffi | grep pkgconfig | xargs dirname) pkg-config --silence-errors --libs libffi)
-	# use bison installed by homebrew if available
-	BISON = $(shell (brew list bison | grep -m1 "bin/bison") || echo bison)
-	SED = sed
+# homebrew search paths
+ifneq ($(shell which brew),)
+BREW_PREFIX := $(shell brew --prefix)/opt
+CXXFLAGS += -I$(BREW_PREFIX)/readline/include
+LDFLAGS += -L$(BREW_PREFIX)/readline/lib
+PKG_CONFIG_PATH := $(BREW_PREFIX)/libffi/lib/pkgconfig:$(PKG_CONFIG_PATH)
+PKG_CONFIG_PATH := $(BREW_PREFIX)/tcl-tk/lib/pkgconfig:$(PKG_CONFIG_PATH)
+export PATH := $(BREW_PREFIX)/bison/bin:$(BREW_PREFIX)/gettext/bin:$(BREW_PREFIX)/flex/bin:$(PATH)
+
+# macports search paths
+else ifneq ($(shell which port),)
+PORT_PREFIX := $(patsubst %/bin/port,%,$(shell which port))
+CXXFLAGS += -I$(PORT_PREFIX)/include
+LDFLAGS += -L$(PORT_PREFIX)/lib
+PKG_CONFIG_PATH := $(PORT_PREFIX)/lib/pkgconfig:$(PKG_CONFIG_PATH)
+export PATH := $(PORT_PREFIX)/bin:$(PATH)
+endif
 else
-	LDFLAGS += -rdynamic
-	LDLIBS += -lrt
+LDFLAGS += -rdynamic
+LDLIBS += -lrt
 endif

 YOSYS_VER := 0.7
@@ -202,15 +210,16 @@ endif
 endif

 ifeq ($(ENABLE_PLUGINS),1)
-CXXFLAGS += -DYOSYS_ENABLE_PLUGINS $(shell $(PKG_CONFIG) --silence-errors --cflags libffi)
-LDLIBS += $(shell $(PKG_CONFIG) --silence-errors --libs libffi || echo -lffi) -ldl
+CXXFLAGS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --silence-errors --cflags libffi) -DYOSYS_ENABLE_PLUGINS
+LDLIBS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --silence-errors --libs libffi || echo -lffi) -ldl
 endif

 ifeq ($(ENABLE_TCL),1)
 TCL_VERSION ?= tcl$(shell bash -c "tclsh <(echo 'puts [info tclversion]')")
 TCL_INCLUDE ?= /usr/include/$(TCL_VERSION)
-CXXFLAGS += -I$(TCL_INCLUDE) -DYOSYS_ENABLE_TCL
-LDLIBS += -l$(TCL_VERSION)
+
+CXXFLAGS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --silence-errors --cflags tcl || echo -I$(TCL_INCLUDE)) -DYOSYS_ENABLE_TCL
+LDLIBS += $(shell PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) $(PKG_CONFIG) --silence-errors --libs tcl || echo -l$(TCL_VERSION))
 endif

 ifeq ($(ENABLE_GPROF),1)
