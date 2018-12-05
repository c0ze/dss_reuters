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

  it "should extract with Ric" do
    VCR.use_cassette "extract_with_ric" do
      api = DssReuters::Api.new
      req = api.extract_with_ric ".TRXFLDAUTFIN"
      req.get_result
      expect(req.status).to eq :complete
      expect(req.result["Contents"])
        .to eq(
              [{"IdentifierType"=>"Ric",
                "Identifier"=>".TRXFLDAUTFIN",
                "Close Price"=>650.66,
                "Contributor Code Description"=>"Thomson Reuters",
                "Currency Code Description"=>"Australian Dollar",
                "Dividend Yield"=>nil,
                "Main Index"=>nil,
                "Market Capitalization"=>25735172267.3505,
                "Market Capitalization - Local Currency"=>"CAD",
                "Percent Change - Close Price - 1 Day"=>-1.002662609,
                "Universal Close Price Date"=>"2018-12-04"}]
            )
    end
  end

  it "should extract with Ric time series" do
    VCR.use_cassette "extract_with_ric_time_series" do
      api = DssReuters::Api.new
      req = api.extract_with_ric ".TRXFLDAUTFIN",
                                 :time_series,
                                 ["Close Price", "Trade Date"],
                                 {"StartDate" => "2018-01-01", "EndDate" => "2018-04-01"}
      req.get_result
      expect(req.status).to eq :complete
      expect(req.result["Contents"])
        .to eq(
              [{"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>646.51, "Trade Date"=>"2018-03-30"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>646.51, "Trade Date"=>"2018-03-29"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>646.69, "Trade Date"=>"2018-03-28"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>650.54, "Trade Date"=>"2018-03-27"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>649.17, "Trade Date"=>"2018-03-26"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>653.8, "Trade Date"=>"2018-03-23"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>666.51, "Trade Date"=>"2018-03-22"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>669.9, "Trade Date"=>"2018-03-21"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>667.53, "Trade Date"=>"2018-03-20"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>667.97, "Trade Date"=>"2018-03-19"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>668.13, "Trade Date"=>"2018-03-16"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>669.19, "Trade Date"=>"2018-03-15"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>673.92, "Trade Date"=>"2018-03-14"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>679.55, "Trade Date"=>"2018-03-13"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>681.02, "Trade Date"=>"2018-03-12"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>678.42, "Trade Date"=>"2018-03-09"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>673.67, "Trade Date"=>"2018-03-08"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>668.37, "Trade Date"=>"2018-03-07"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>675.03, "Trade Date"=>"2018-03-06"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>670.17, "Trade Date"=>"2018-03-05"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>674.45, "Trade Date"=>"2018-03-02"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.28, "Trade Date"=>"2018-03-01"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>679.33, "Trade Date"=>"2018-02-28"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>683.72, "Trade Date"=>"2018-02-27"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>680.7, "Trade Date"=>"2018-02-26"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>673.09, "Trade Date"=>"2018-02-23"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>668.21, "Trade Date"=>"2018-02-22"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>667.19, "Trade Date"=>"2018-02-21"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>664.01, "Trade Date"=>"2018-02-20"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>664.58, "Trade Date"=>"2018-02-19"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>660.37, "Trade Date"=>"2018-02-16"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>661.62, "Trade Date"=>"2018-02-15"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>656.54, "Trade Date"=>"2018-02-14"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>657.6, "Trade Date"=>"2018-02-13"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>653.86, "Trade Date"=>"2018-02-12"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>657.56, "Trade Date"=>"2018-02-09"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>661.05, "Trade Date"=>"2018-02-08"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>656.36, "Trade Date"=>"2018-02-07"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>656.13, "Trade Date"=>"2018-02-06"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.51, "Trade Date"=>"2018-02-05"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>686.41, "Trade Date"=>"2018-02-02"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>683.94, "Trade Date"=>"2018-02-01"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.15, "Trade Date"=>"2018-01-31"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>674.93, "Trade Date"=>"2018-01-30"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>679.12, "Trade Date"=>"2018-01-29"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.07, "Trade Date"=>"2018-01-26"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.07, "Trade Date"=>"2018-01-25"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>678.62, "Trade Date"=>"2018-01-24"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.04, "Trade Date"=>"2018-01-23"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>671.92, "Trade Date"=>"2018-01-22"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>676.58, "Trade Date"=>"2018-01-19"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.69, "Trade Date"=>"2018-01-18"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>675.76, "Trade Date"=>"2018-01-17"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>677.11, "Trade Date"=>"2018-01-16"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>680.64, "Trade Date"=>"2018-01-15"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>680.94, "Trade Date"=>"2018-01-12"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>684.04, "Trade Date"=>"2018-01-11"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>686.67, "Trade Date"=>"2018-01-10"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>690.25, "Trade Date"=>"2018-01-09"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>689.86, "Trade Date"=>"2018-01-08"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>688.07, "Trade Date"=>"2018-01-05"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>682.68, "Trade Date"=>"2018-01-04"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>682.84, "Trade Date"=>"2018-01-03"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>683.32, "Trade Date"=>"2018-01-02"},
               {"IdentifierType"=>"Ric", "Identifier"=>".TRXFLDAUTFIN", "Close Price"=>684.94, "Trade Date"=>"2018-01-01"}]
            )
    end
  end
end
