require "dss_reuters"
require "pry"

describe DataStream do
  it "should login" do
    VCR.use_cassette "data_stream_login", record: :new_episodes do
      api = DataStream::Api.new
      expect(api.session).not_to be_nil
      expect(api.session.token).not_to be_nil
    end
  end

  it "should stream RIC" do
    VCR.use_cassette "data_stream_ric", record: :new_episodes do
      ric = ".TRXFLDAUTFIN"
      date_start = "2018-01-01"
      date_end = "2018-04-01"
      api = DataStream::Api.new
      res = api.ric_stream ric, date_start, date_end
      expect(res).to eq(
                       [{:date=>"2018-01-01", :value=>684.94},
                        {:date=>"2018-01-02", :value=>683.32},
                        {:date=>"2018-01-03", :value=>682.84},
                        {:date=>"2018-01-04", :value=>682.68},
                        {:date=>"2018-01-05", :value=>688.07},
                        {:date=>"2018-01-08", :value=>689.86},
                        {:date=>"2018-01-09", :value=>690.25},
                        {:date=>"2018-01-10", :value=>686.67},
                        {:date=>"2018-01-11", :value=>684.04},
                        {:date=>"2018-01-12", :value=>680.94},
                        {:date=>"2018-01-15", :value=>680.64},
                        {:date=>"2018-01-16", :value=>677.11},
                        {:date=>"2018-01-17", :value=>675.76},
                        {:date=>"2018-01-18", :value=>677.69},
                        {:date=>"2018-01-19", :value=>676.58},
                        {:date=>"2018-01-22", :value=>671.92},
                        {:date=>"2018-01-23", :value=>677.04},
                        {:date=>"2018-01-24", :value=>678.62},
                        {:date=>"2018-01-25", :value=>677.07},
                        {:date=>"2018-01-26", :value=>677.07},
                        {:date=>"2018-01-29", :value=>679.12},
                        {:date=>"2018-01-30", :value=>674.93},
                        {:date=>"2018-01-31", :value=>677.15},
                        {:date=>"2018-02-01", :value=>683.94},
                        {:date=>"2018-02-02", :value=>686.41},
                        {:date=>"2018-02-05", :value=>677.51},
                        {:date=>"2018-02-06", :value=>656.13},
                        {:date=>"2018-02-07", :value=>656.36},
                        {:date=>"2018-02-08", :value=>661.05},
                        {:date=>"2018-02-09", :value=>657.56},
                        {:date=>"2018-02-12", :value=>653.86},
                        {:date=>"2018-02-13", :value=>657.6},
                        {:date=>"2018-02-14", :value=>656.54},
                        {:date=>"2018-02-15", :value=>661.62},
                        {:date=>"2018-02-16", :value=>660.37},
                        {:date=>"2018-02-19", :value=>664.58},
                        {:date=>"2018-02-20", :value=>664.01},
                        {:date=>"2018-02-21", :value=>667.19},
                        {:date=>"2018-02-22", :value=>668.21},
                        {:date=>"2018-02-23", :value=>673.09},
                        {:date=>"2018-02-26", :value=>680.7},
                        {:date=>"2018-02-27", :value=>683.72},
                        {:date=>"2018-02-28", :value=>679.33},
                        {:date=>"2018-03-01", :value=>677.28},
                        {:date=>"2018-03-02", :value=>674.45},
                        {:date=>"2018-03-05", :value=>670.17},
                        {:date=>"2018-03-06", :value=>675.03},
                        {:date=>"2018-03-07", :value=>668.37},
                        {:date=>"2018-03-08", :value=>673.67},
                        {:date=>"2018-03-09", :value=>678.42},
                        {:date=>"2018-03-12", :value=>681.02},
                        {:date=>"2018-03-13", :value=>679.55},
                        {:date=>"2018-03-14", :value=>673.92},
                        {:date=>"2018-03-15", :value=>669.19},
                        {:date=>"2018-03-16", :value=>668.13},
                        {:date=>"2018-03-19", :value=>667.97},
                        {:date=>"2018-03-20", :value=>667.53},
                        {:date=>"2018-03-21", :value=>669.9},
                        {:date=>"2018-03-22", :value=>666.51},
                        {:date=>"2018-03-23", :value=>653.8},
                        {:date=>"2018-03-26", :value=>649.17},
                        {:date=>"2018-03-27", :value=>650.54},
                        {:date=>"2018-03-28", :value=>646.69},
                        {:date=>"2018-03-29", :value=>646.51},
                        {:date=>"2018-03-30", :value=>646.51}]
                     )
    end
  end

  it "should stream ISIN" do
    VCR.use_cassette "data_stream_isin", record: :new_episodes do
      isin = "KE1000001402"
      date_start = "2018-01-01"
      date_end = "2018-04-01"
      api = DataStream::Api.new
      res = api.isin_stream isin, date_start, date_end
      expect(res).to eq(
                       [{:date=>"2018-01-01", :value=>26.75},
                        {:date=>"2018-01-02", :value=>26.75},
                        {:date=>"2018-01-03", :value=>26.75},
                        {:date=>"2018-01-04", :value=>27},
                        {:date=>"2018-01-05", :value=>28},
                        {:date=>"2018-01-08", :value=>28},
                        {:date=>"2018-01-09", :value=>28},
                        {:date=>"2018-01-10", :value=>27.75},
                        {:date=>"2018-01-11", :value=>27.75},
                        {:date=>"2018-01-12", :value=>28.25},
                        {:date=>"2018-01-15", :value=>28.75},
                        {:date=>"2018-01-16", :value=>29},
                        {:date=>"2018-01-17", :value=>29},
                        {:date=>"2018-01-18", :value=>29.25},
                        {:date=>"2018-01-19", :value=>29.5},
                        {:date=>"2018-01-22", :value=>29.25},
                        {:date=>"2018-01-23", :value=>29.5},
                        {:date=>"2018-01-24", :value=>29.5},
                        {:date=>"2018-01-25", :value=>29.75},
                        {:date=>"2018-01-26", :value=>30},
                        {:date=>"2018-01-29", :value=>29.75},
                        {:date=>"2018-01-30", :value=>29.75},
                        {:date=>"2018-01-31", :value=>29.5},
                        {:date=>"2018-02-01", :value=>29.75},
                        {:date=>"2018-02-02", :value=>29.75},
                        {:date=>"2018-02-05", :value=>29.75},
                        {:date=>"2018-02-06", :value=>29.5},
                        {:date=>"2018-02-07", :value=>28.5},
                        {:date=>"2018-02-08", :value=>29.25},
                        {:date=>"2018-02-09", :value=>29},
                        {:date=>"2018-02-12", :value=>28.25},
                        {:date=>"2018-02-13", :value=>28.5},
                        {:date=>"2018-02-14", :value=>28.75},
                        {:date=>"2018-02-15", :value=>28.75},
                        {:date=>"2018-02-16", :value=>29.25},
                        {:date=>"2018-02-19", :value=>29.25},
                        {:date=>"2018-02-20", :value=>29.75},
                        {:date=>"2018-02-21", :value=>29.75},
                        {:date=>"2018-02-22", :value=>29.5},
                        {:date=>"2018-02-23", :value=>29.5},
                        {:date=>"2018-02-26", :value=>29.5},
                        {:date=>"2018-02-27", :value=>29.5},
                        {:date=>"2018-02-28", :value=>29.75},
                        {:date=>"2018-03-01", :value=>29.5},
                        {:date=>"2018-03-02", :value=>29.25},
                        {:date=>"2018-03-05", :value=>29.25},
                        {:date=>"2018-03-06", :value=>29.25},
                        {:date=>"2018-03-07", :value=>29.5},
                        {:date=>"2018-03-08", :value=>29.5},
                        {:date=>"2018-03-09", :value=>29.25},
                        {:date=>"2018-03-12", :value=>29.25},
                        {:date=>"2018-03-13", :value=>29.75},
                        {:date=>"2018-03-14", :value=>29.75},
                        {:date=>"2018-03-15", :value=>29.5},
                        {:date=>"2018-03-16", :value=>29.5},
                        {:date=>"2018-03-19", :value=>30},
                        {:date=>"2018-03-20", :value=>30.75},
                        {:date=>"2018-03-21", :value=>31.25},
                        {:date=>"2018-03-22", :value=>31.75},
                        {:date=>"2018-03-23", :value=>31.75},
                        {:date=>"2018-03-26", :value=>31.5},
                        {:date=>"2018-03-27", :value=>31.25},
                        {:date=>"2018-03-28", :value=>30.75},
                        {:date=>"2018-03-29", :value=>31},
                        {:date=>"2018-03-30", :value=>31}]
                     )
    end
  end

  it "should return same results for ISIN and Ric" do
    VCR.use_cassette "data_stream_isin_vs_ric", record: :new_episodes do
      isin = "KE1000001402"
      date_start = "2018-01-01"
      date_end = "2018-04-01"
      api = DataStream::Api.new
      isin_res = api.isin_stream isin, date_start, date_end
      ric = "SCOM.NR"
      ric_res = api.ric_stream ric, date_start, date_end
      expect(isin_res).to eq(ric_res)
    end
  end
end
