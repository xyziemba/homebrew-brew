require "language/go"

class Dns2https < Formula
  desc "DNS to DNS-over-HTTPS proxy"
  homepage "https://github.com/xyziemba/dns2https/"
  url "https://github.com/xyziemba/dns2https/archive/v0.1.tar.gz"
  sha256 "3003df57327d9f927bb06079728cca7961a979a877969775d311a5c66e9bd3e1"
  head "https://github.com/xyziemba/dns2https.git"

  depends_on "go" => :build

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
        :revision => "e46719b2fef404d2e531c0dd9055b1c95ff01e2e"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyziemba").mkpath
    ln_sf buildpath, buildpath/"src/github.com/xyziemba/dns2https"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"dns2https"
  end

  plist_options :startup => true, :manual => "dns2https"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{bin}/dns2https</string>
            <key>ProgramArguments</key>
            <array>
                <string>dns2https</string>
                <string>-launchd</string>
            </array>
        <key>KeepAlive</key>
        <true/>
        <key>Sockets</key>
        <dict>
            <key>UdpListener</key>
            <dict>
                <key>SockNodeName</key>
                <string>127.0.0.1</string>
                <key>SockServiceName</key>
                <string>domain</string>
                <key>SockType</key>
                <string>dgram</string>
                <key>SockFamily</key>
                <string>IPv4</string>
            </dict>
            <key>TcpListener</key>
            <dict>
                <key>SockNodeName</key>
                <string>127.0.0.1</string>
                <key>SockServiceName</key>
                <string>domain</string>
                <key>SockType</key>
                <string>stream</string>
                <key>SockFamily</key>
                <string>IPv4</string>
            </dict>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test dns2https`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "#{bin}/dns2https", "-selftest"
  end
end
