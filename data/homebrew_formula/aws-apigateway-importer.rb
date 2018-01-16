class AwsApigatewayImporter < Formula
  desc "AWS API Gateway Importer"
  homepage "https://github.com/awslabs/aws-apigateway-importer"
  url "https://github.com/awslabs/aws-apigateway-importer/archive/aws-apigateway-importer-1.0.1.tar.gz"
  sha256 "8371e3fb1b6333cd50a76fdcdc1280ee8e489aec4bf9a1869325f9b8ebb73b54"
  revision 1

  # Pin aws-sdk-java-core for JSONObject compatibility
  patch do
    url "https://github.com/awslabs/aws-apigateway-importer/commit/660e3ce.diff?full_index=1"
    sha256 "6ff63c504b906e1fb6d0f2a9772761edeef3b37b3dca1e48bba72432d863a852"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3e194aa8c79d1609040430c5d2e804b69df9ffd4cfd0c0501cdecce249591f83" => :high_sierra
    sha256 "65d77c58ac90e7767f93896c9ec95a478dc1388316bcdafb4c06ed10db089caf" => :sierra
    sha256 "bbe12dac66d033674840eace741bcf5c3549e7317ab9ca6fa9f349418a6c9861" => :el_capitan
    sha256 "bbe12dac66d033674840eace741bcf5c3549e7317ab9ca6fa9f349418a6c9861" => :yosemite
  end

  depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install
    system "mvn", "assembly:assembly"
    libexec.install "target/aws-apigateway-importer-1.0.1-jar-with-dependencies.jar"
    bin.write_jar_script libexec/"aws-apigateway-importer-1.0.1-jar-with-dependencies.jar", "aws-api-import"
  end

  test do
    assert_match(/^Usage:\s+aws-api-import/, shell_output("#{bin}/aws-api-import --help"))
  end
end
