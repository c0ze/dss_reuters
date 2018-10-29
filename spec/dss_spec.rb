require "dss_reuters"

describe DssReuters do

  it "should succeed" do
    expect(true).to be_truthy
  end

  it "should login" do
    VCR.use_cassette "login" do
      api = DssReuters::Api.new
    end
  end
end
