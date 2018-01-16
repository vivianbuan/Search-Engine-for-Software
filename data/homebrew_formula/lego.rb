require "language/go"

class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v0.4.1.tar.gz"
  sha256 "365802c02a7f7106370525444c18af53f010153631f27b7cbeb1b4574631f3e7"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "31e0fc916eeba7f0d9afbd97737f5826d4cfcbda2398a005b8cedeec0902b274" => :high_sierra
    sha256 "2bf5ebd638eb8f6b3780c19020d2afa39b67aae6b50899fd91ec42e09b7d9898" => :sierra
    sha256 "73ba30cadb748f5ca76c1757634857af3ead4e1407a8c024d53d8eabbccff9f4" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "cloud.google.com/go" do
    url "https://code.googlesource.com/gocloud.git",
        :revision => "3e1507a0d90d17e4fdd8ef75e8f037ebecc854ba"
  end

  go_resource "github.com/Azure/azure-sdk-for-go" do
    url "https://github.com/Azure/azure-sdk-for-go.git",
        :revision => "7d2af13b1fbbe2e48bc4d2d5d3c580a54274fb15"
  end

  go_resource "github.com/Azure/go-autorest" do
    url "https://github.com/Azure/go-autorest.git",
        :revision => "5b4b9cc27e8f7150d75a133d74b176a067b7e7b6"
  end

  go_resource "github.com/JamesClonk/vultr" do
    url "https://github.com/JamesClonk/vultr.git",
        :revision => "743eb4ae7f548cb4da4e55b9e5a2c9077125bd82"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "8db8ca6fe5d53b066a9a519275dcbd0819345188"
  end

  go_resource "github.com/decker502/dnspod-go" do
    url "https://github.com/decker502/dnspod-go.git",
        :revision => "f33a2c6040fc2550a631de7b3a53bddccdcd73fb"
  end

  go_resource "github.com/dgrijalva/jwt-go" do
    url "https://github.com/dgrijalva/jwt-go.git",
        :revision => "a539ee1a749a2b895533f979515ac7e6e0f5b650"
  end

  go_resource "github.com/dnsimple/dnsimple-go" do
    url "https://github.com/dnsimple/dnsimple-go.git",
        :revision => "5a5b427618a76f9eed5ede0f3e6306fbd9311d2e"
  end

  go_resource "github.com/edeckers/auroradnsclient" do
    url "https://github.com/edeckers/auroradnsclient.git",
        :revision => "8b777c170cfd377aa16bb4368f093017dddef3f9"
  end

  go_resource "github.com/exoscale/egoscale" do
    url "https://github.com/exoscale/egoscale.git",
        :revision => "325740036187ddae3a5b74be00fbbc70011c4d96"
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring.git",
        :revision => "53e6ce116135b80d037921a7fdd5138cf32d7a8a"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "0559e6d230af0a3a7273853cb6994ebea21bfbe5"
  end

  go_resource "github.com/ovh/go-ovh" do
    url "https://github.com/ovh/go-ovh.git",
        :revision => "d95f6f91b1fb339a53fc438df7289cd85756193b"
  end

  go_resource "github.com/rainycape/memcache" do
    url "https://github.com/rainycape/memcache.git",
        :revision => "1031fa0ce2f20c1c0e1e1b51951d8ea02c84fa05"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "890a5c3458b43e6104ff5da8dfa139d013d77544"
  end

  go_resource "github.com/timewasted/linode" do
    url "https://github.com/timewasted/linode.git",
        :revision => "37e84520dcf74488f67654f9c775b9752c232dc1"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
        :revision => "4b90d79a682b4bf685762c7452db20f2a676ecb2"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "dd85ac7e6a88fc6ca420478e934de5f1a42dd3c6"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "f01ecb60fe3835d80d9a0b7b2bf24b228c89260e"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
        :revision => "cce311a261e6fcf29de72ca96827bdb0b7d9c9e6"
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
        :revision => "e665075b5ff79143ba49c58fab02df9dc122afd5"
  end

  go_resource "gopkg.in/ini.v1" do
    url "https://gopkg.in/ini.v1.git",
        :revision => "d3de07a94d22b4a0972deb4b96d790c2c0ce8333"
  end

  go_resource "gopkg.in/ns1/ns1-go.v2" do
    url "https://gopkg.in/ns1/ns1-go.v2.git",
        :revision => "c563826f4cbef9c11bebeb9f20a3f7afe9c1e2f4"
  end

  go_resource "gopkg.in/square/go-jose.v1" do
    url "https://gopkg.in/square/go-jose.v1.git",
        :revision => "aa2e30fdd1fe9dd3394119af66451ae790d50e0d"
  end

  def install
    ENV["GOPATH"] = buildpath

    Language::Go.stage_deps resources, buildpath/"src"
    (buildpath/"src/github.com/xenolf").mkpath
    ln_s buildpath, buildpath/"src/github.com/xenolf/lego"

    system "go", "build", "-o", bin/"lego", "./src/github.com/xenolf/lego"
  end

  test do
    system bin/"lego", "-v"
  end
end
