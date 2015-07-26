class Chronology < Formula
  desc "File watcher for git repositories"
  homepage "https://bitbucket.org/xyziemba/chronology"
  url "https://bitbucket.org/xyziemba/chronology/get/HEAD.zip"
  version "0.0.1"
  #sha256 "" # todo: provide a hash once there's a real version of this

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on :xcode

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-1.1.2.tar.gz"
    sha256 "390970b602708c91ddc73953bb6929e56291c18a4d80f360afa00fad8b6f3339"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pygit2" do
    url "https://pypi.python.org/packages/source/p/pygit2/pygit2-0.22.1.tar.gz"
    sha256 "f2533544a10a6dedb8f6eb36bc569285fd14294a72eebc0dc713281eb13ce476"
  end

  resource "pyuv" do
    url "https://pypi.python.org/packages/source/p/pyuv/pyuv-1.1.0.tar.gz"
    sha256 "bd0187371a4944fb3ea0c843890a5a97f77249b97c816d4a71d3a3456c99a54c"
  end

  resource "psutil" do
    url "https://pypi.python.org/packages/source/p/psutil/psutil-3.1.1.tar.gz"
    sha256 "d3290bd4a027fa0b3a2e2ee87728056fe49d4112640e2b8c2ea4dd94ba0cf057"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test chronology`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
