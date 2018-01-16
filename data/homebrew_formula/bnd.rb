class Bnd < Formula
  desc "The Swiss Army Knife for OSGi bundles"
  homepage "http://bnd.bndtools.org/"
  url "https://search.maven.org/remotecontent?filepath=biz/aQute/bnd/biz.aQute.bnd/3.5.0/biz.aQute.bnd-3.5.0.jar"
  sha256 "6ecfd9b416eb637f6cdd0caa9e86a86ffe9a4c6215de4260824b5669ada160c6"

  bottle :unneeded

  def install
    libexec.install "biz.aQute.bnd-#{version}.jar"
    bin.write_jar_script libexec/"biz.aQute.bnd-#{version}.jar", "bnd"
  end

  test do
    # Test bnd by resolving a launch.bndrun file against a trivial index.
    test_sha = "baad835c6fa65afc1695cc92a9e1afe2967e546cae94d59fa9e49b557052b2b1"
    test_bsn = "org.apache.felix.gogo.runtime"
    test_version = "1.0.0"
    test_version_next = "1.0.1"
    test_file_name = "#{test_bsn}-#{test_version}.jar"
    (testpath/"index.xml").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <repository increment="0" name="Untitled" xmlns="http://www.osgi.org/xmlns/repository/v1.0.0">
        <resource>
          <capability namespace="osgi.identity">
            <attribute name="osgi.identity" value="#{test_bsn}"/>
            <attribute name="version" type="Version" value="#{test_version}"/>
          </capability>
          <capability namespace="osgi.content">
            <attribute name="osgi.content" value="#{test_sha}"/>
            <attribute name="url" value="#{test_file_name}"/>
          </capability>
        </resource>
      </repository>
    EOS

    (testpath/"launch.bndrun").write <<~EOS
      -standalone: index.xml
      -runrequires: osgi.identity;filter:='(osgi.identity=#{test_bsn})'
    EOS

    output = shell_output("#{bin}/bnd resolve resolve -b launch.bndrun")
    assert_match /launch.bndrun\s+ok/, output
    assert_match /#{test_bsn};version='\[#{test_version},#{test_version_next}\)/, output
  end
end
