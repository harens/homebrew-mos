class Mos < Formula
  include Language::Python::Virtualenv

  # update_hb begin
  desc "Mongoose OS command-line tool"
  homepage "https://mongoose-os.com/"
  url "https://github.com/mongoose-os/mos/archive/1ec85951e77649f1151bc06a12901faa784a991a.tar.gz"
  sha256 "1d95538be29219a487ec21724f65ca9e4ab28341e2a722ac6dd6abd249560583"
  version "2.18.0"
  head ""

  bottle do
    root_url "https://mongoose-os.com/downloads/homebrew/bottles-mos"
    cellar :any
    sha256 "38d13ab2e6cef41dc0ea1fa70b40ba4964b079696f55362459a42fbbb2598cf0" => :catalina # 2.18.0
  end
  # update_hb end

  head "https://github.com/mongoose-os/mos.git"

  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat"
  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "python3" => :build

  conflicts_with "mos-latest", :because => "Use mos or mos-latest, not both"

  def install
    cd buildpath do
      # The build will be performed not from a git repo, so we have to specify
      # version and build id manually. Use "brew" as a distro name so that mos
      # won't update itself.
      build_id = format("%s~brew", version)
      File.open("pkg.version", "w") { |file| file.write(version) }
      File.open("pkg.build_id", "w") { |file| file.write(build_id) }

      system "make", "mos"
      bin.install "mos"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"mos", "version"
  end
end
