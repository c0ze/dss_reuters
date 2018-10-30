require "dss_reuters"
require "pry"

describe DssReuters do
  it "should login" do
    VCR.use_cassette "login" do
      api = DssReuters::Api.new
      expect(api.session).not_to be_nil
      expect(api.session.token).not_to be_nil
    end
  end

  it "should extract with ISIN" do
    VCR.use_cassette "extract_with_isin" do
      api = DssReuters::Api.new
      req = api.extract_with_isin "KE1000001402"
      expect(req.location).not_to be_nil
      expect(req.status).to eq :in_progress
    end
  end

  it "should get result" do
    VCR.use_cassette "get_result" do
      api = DssReuters::Api.new
      req = api.extract_with_isin "KE1000001402"
      req.get_result
      expect(req.result).not_to be_nil
      expect(req.status).to eq :complete
    end
  end

  it "should extract with location" do
    VCR.use_cassette "extract_with_location" do
      api = DssReuters::Api.new
      req = api.extract_with_location "https://hosted.datascopeapi.reuters.com/RestApi/v1/Extractions/ExtractWithNotesResult(ExtractionId='0x066341ce7e301788')"
      req.get_result
      expect(req.result).not_to be_nil
      expect(req.status).to eq :complete
    end
  end
end
