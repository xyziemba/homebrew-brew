# Documentation: https://docs.brew.sh/Formula-Cookbook.html
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
require "language/go"

class Derptris < Formula
  desc ""
  homepage ""
  url "https://github.com/xyziemba/derptris.git",
      :revision => "162c304730ad4fcb33d0eb73b262b89c92b19113"
  version "0.0.2"
  sha256 ""

  depends_on "go" => :build

  go_resource "github.com/pkg/term" do
    url "https://github.com/pkg/term.git",
        :revision => "b1f72af2d63057363398bec5873d16a98b453312"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xyziemba/derptris").install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd buildpath/"src/github.com/xyziemba/derptris" do
      system "go", "build", "-o", bin/"derptris", "github.com/xyziemba/derptris"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test derptris`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
