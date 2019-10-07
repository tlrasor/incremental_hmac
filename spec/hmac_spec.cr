require "./spec_helper"

SMALL_TEST_DATA = Path[__FILE__].parent.join("jekyll_hyde.txt")
KEY             = "6ed117753cb1f2684a8a9b4b090ba368d3bb69b6847cb7aa42b695808a8ac9f4"

describe OpenSSL::HMAC do
  describe "#hexdigest" do
    str_digest = OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, KEY, File.read(SMALL_TEST_DATA))

    it "works on a path like on a string" do
      digest = OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, KEY, SMALL_TEST_DATA)
      digest.should eq(str_digest)
    end
  end
end
