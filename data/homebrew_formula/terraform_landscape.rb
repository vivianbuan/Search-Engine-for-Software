class TerraformLandscape < Formula
  desc "Improve Terraform's plan output"
  homepage "https://github.com/coinbase/terraform-landscape"
  url "https://github.com/coinbase/terraform-landscape/archive/v0.1.17.tar.gz"
  sha256 "ffc89c435d673de353db17f9e9796de95c55e1236071178dc35102a99917fd45"
  revision 3

  bottle do
    cellar :any_skip_relocation
    sha256 "1359014f1c085eab4504073128620a0f7d15110e5bd486237102a8625795ec8d" => :high_sierra
    sha256 "7591a60f166b102d15c8498e84215f09f3977bd4bfbd0b6142bf3f1af547fad0" => :sierra
    sha256 "b505ec407bdca7dfd380007edc3f97216401a400ff4510cc8033e978f2aae642" => :el_capitan
  end

  depends_on "ruby" if MacOS.version <= :mountain_lion

  resource "colorize" do
    url "https://rubygems.org/gems/colorize-0.8.1.gem"
    sha256 "0ba0c2a58232f9b706dc30621ea6aa6468eeea120eb6f1ccc400105b90c4798c"
  end

  resource "commander" do
    url "https://rubygems.org/gems/commander-4.4.3.gem"
    sha256 "aedf4af6fdf8f05489001bcd70af87d83afec6896a3a2dfd9b49ec02bc391d07"
  end

  resource "diffy" do
    url "https://rubygems.org/gems/diffy-3.2.0.gem"
    sha256 "8124e5b1d9c0086994b6484d26f37476b79253309ccaebea201247a67eb2b604"
  end

  resource "highline" do
    url "https://rubygems.org/gems/highline-1.7.8.gem"
    sha256 "795274094fd385bfe45a2ac7b68462b6ba43e21bf311dbdca5225a63dba3c5d9"
  end

  resource "polyglot" do
    url "https://rubygems.org/gems/polyglot-0.3.5.gem"
    sha256 "59d66ef5e3c166431c39cb8b7c1d02af419051352f27912f6a43981b3def16af"
  end

  resource "treetop" do
    url "https://rubygems.org/gems/treetop-1.6.8.gem"
    sha256 "385cbbf3827a0a8559e4c79db0f0f88993dca5e8ce46cf08f1baccb61ac6a3cf"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.verify_download_integrity(r.fetch)
      system "gem", "install", r.cached_download, "--no-document",
                    "--install-dir", libexec
    end
    system "gem", "build", "terraform_landscape.gemspec"
    system "gem", "install", "--ignore-dependencies", "terraform_landscape-#{version}.gem"
    bin.install libexec/"bin/landscape"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/landscape -v")
    assert_match "Terraform Landscape #{version}", output

    test_input = "+ some_resource_type.some_resource_name"
    colorized_expected_output = "\e[0;32;49m+ some_resource_type.some_resource_name\e[0m\n\n\n"

    output = shell_output("echo '#{test_input}' | #{bin}/landscape")
    assert_match colorized_expected_output, output
  end
end
