class GnomeRecipes < Formula
  desc "Formula for GNOME recipes"
  homepage "https://wiki.gnome.org/Apps/Recipes"
  url "https://download.gnome.org/sources/gnome-recipes/2.0/gnome-recipes-2.0.2.tar.xz"
  sha256 "1be9d2fcb7404a97aa029d2409880643f15071c37039247a6a4320e7478cd5fb"
  revision 2

  bottle do
    sha256 "9250ea26b664e3ec8982762710969f15582b7e87e11e989584294a6147c07926" => :high_sierra
    sha256 "e44081479d677544aa1c89cf1fcd2aef07f6afd6fa4eb81fe9a0a39677ae0e0c" => :sierra
    sha256 "5271c2503df67137bce7a6eb04c581474e23015332ea0aed73870a849053d973" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "itstool" => :build
  depends_on "python3" => :build
  depends_on "gtk+3"
  depends_on "adwaita-icon-theme"
  depends_on "libcanberra"
  depends_on "gnome-autoar"
  depends_on "gspell"
  depends_on "libsoup"
  depends_on "gnu-tar"

  # dependencies for goa
  depends_on "intltool" => :build
  depends_on "json-glib"
  depends_on "librest"

  resource "goa" do
    url "https://download.gnome.org/sources/gnome-online-accounts/3.26/gnome-online-accounts-3.26.1.tar.xz"
    sha256 "603c110405cb89a01497a69967f10e3f3f36add3dc175b062ec4c5ed4485621b"
  end

  def install
    resource("goa").stage do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--disable-backend"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    # BSD tar does not support the required options
    inreplace "src/gr-recipe-store.c", "argv[0] = \"tar\";", "argv[0] = \"gtar\";"
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = ""
    ENV.delete "PYTHONPATH"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gnome-recipes", "--help"
  end
end
