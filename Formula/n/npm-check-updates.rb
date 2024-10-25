class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.6.tgz"
  sha256 "39a29553f93091a8b9b33f52616f4e041c84eb476dad0f3db7c029ef5a01129a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93e1641fc91e68cf908eb83d4db12fa8461f2624ea27c027767cb9f131341d78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93e1641fc91e68cf908eb83d4db12fa8461f2624ea27c027767cb9f131341d78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93e1641fc91e68cf908eb83d4db12fa8461f2624ea27c027767cb9f131341d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bf7b7cf4a557f778fd1f7d085b758f5d48cefa6827586646cee4f919b3728a5"
    sha256 cellar: :any_skip_relocation, ventura:       "5bf7b7cf4a557f778fd1f7d085b758f5d48cefa6827586646cee4f919b3728a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93e1641fc91e68cf908eb83d4db12fa8461f2624ea27c027767cb9f131341d78"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~EOS
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    EOS

    system bin/"ncu", "-u"

    # Read the updated package.json to get the new dependency versions
    updated_package_json = JSON.parse(test_package_json.read)
    updated_express_version = updated_package_json["dependencies"]["express"]
    updated_lodash_version = updated_package_json["dependencies"]["lodash"]

    # Assert that both dependencies have been updated to higher versions
    assert Gem::Version.new(updated_express_version) > Gem::Version.new("1.8.7"),
      "Express version not updated as expected"
    assert Gem::Version.new(updated_lodash_version) > Gem::Version.new("3.6.1"),
      "Lodash version not updated as expected"
  end
end
