class Fdupes < Formula
  desc "Identify or delete duplicate files"
  homepage "https://github.com/adrianlopezroche/fdupes"
  url "https://github.com/adrianlopezroche/fdupes/archive/v1.6.1.tar.gz"
  sha256 "9d6b6fdb0b8419815b4df3bdfd0aebc135b8276c90bbbe78ebe6af0b88ba49ea"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2ca42f56f5b4e48a4a51cf9687108eb2ebbbf43ce610596d4420be1a68f1ec1b" => :high_sierra
    sha256 "4838e3104ea06e61d7acce5f482ff80bae1d634f29a1edd44e388b9f8c63f19b" => :sierra
    sha256 "b0b7afcd64459cfc3c2bb95ac92e1aa7f6531fbf05603e472c97c5d4e72c94b7" => :el_capitan
    sha256 "ce706b289e019a30c4d07a307ae2c5c10ef1b886e4ee8e5e62f7275a9213a370" => :yosemite
  end

  def install
    inreplace "Makefile", "gcc", "#{ENV.cc} #{ENV.cflags}"
    system "make", "fdupes"
    bin.install "fdupes"
    man1.install "fdupes.1"
  end

  test do
    touch "a"
    touch "b"

    dupes = shell_output("#{bin}/fdupes .").strip.split("\n").sort
    assert_equal ["./a", "./b"], dupes
  end
end
