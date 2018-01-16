class Getmail < Formula
  desc "Extensible mail retrieval system with POP3, IMAP4, SSL support"
  homepage "http://pyropus.ca/software/getmail/"
  url "http://pyropus.ca/software/getmail/old-versions/getmail-5.5.tar.gz"
  sha256 "e0382ee59f1ec6ac2d6f01b71ca71db0826db0d267704b2bc2d97b9beda28350"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d5cd5119d410de2641ba8c2c525ba5139ccc65b0670160aa4ebd3fcedd84c01" => :high_sierra
    sha256 "1d5cd5119d410de2641ba8c2c525ba5139ccc65b0670160aa4ebd3fcedd84c01" => :sierra
    sha256 "1d5cd5119d410de2641ba8c2c525ba5139ccc65b0670160aa4ebd3fcedd84c01" => :el_capitan
  end

  def install
    libexec.install %w[getmail getmail_fetch getmail_maildir getmail_mbox]
    bin.install_symlink Dir["#{libexec}/*"]
    libexec.install "getmailcore"
    man1.install Dir["docs/*.1"]
  end

  test do
    system bin/"getmail", "--help"
  end
end
