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
                       [{:date=>"2018-01-01", :value=>13},
                        {:date=>"2018-01-02", :value=>13},
                        {:date=>"2018-01-03", :value=>13},
                        {:date=>"2018-01-04", :value=>13},
                        {:date=>"2018-01-05", :value=>13},
                        {:date=>"2018-01-08", :value=>13},
                        {:date=>"2018-01-09", :value=>13},
                        {:date=>"2018-01-10", :value=>13},
                        {:date=>"2018-01-11", :value=>13},
                        {:date=>"2018-01-12", :value=>13},
                        {:date=>"2018-01-15", :value=>13},
                        {:date=>"2018-01-16", :value=>13},
                        {:date=>"2018-01-17", :value=>13},
                        {:date=>"2018-01-18", :value=>13},
                        {:date=>"2018-01-19", :value=>13},
                        {:date=>"2018-01-22", :value=>13},
                        {:date=>"2018-01-23", :value=>13},
                        {:date=>"2018-01-24", :value=>13},
                        {:date=>"2018-01-25", :value=>13},
                        {:date=>"2018-01-26", :value=>13},
                        {:date=>"2018-01-29", :value=>13},
                        {:date=>"2018-01-30", :value=>13},
                        {:date=>"2018-01-31", :value=>13},
                        {:date=>"2018-02-01", :value=>13},
                        {:date=>"2018-02-02", :value=>13},
                        {:date=>"2018-02-05", :value=>13},
                        {:date=>"2018-02-06", :value=>13},
                        {:date=>"2018-02-07", :value=>13},
                        {:date=>"2018-02-08", :value=>13},
                        {:date=>"2018-02-09", :value=>13},
                        {:date=>"2018-02-12", :value=>13},
                        {:date=>"2018-02-13", :value=>13},
                        {:date=>"2018-02-14", :value=>13},
                        {:date=>"2018-02-15", :value=>13},
                        {:date=>"2018-02-16", :value=>13},
                        {:date=>"2018-02-19", :value=>13},
                        {:date=>"2018-02-20", :value=>13},
                        {:date=>"2018-02-21", :value=>13},
                        {:date=>"2018-02-22", :value=>13},
                        {:date=>"2018-02-23", :value=>13},
                        {:date=>"2018-02-26", :value=>13},
                        {:date=>"2018-02-27", :value=>13},
                        {:date=>"2018-02-28", :value=>13},
                        {:date=>"2018-03-01", :value=>13},
                        {:date=>"2018-03-02", :value=>13},
                        {:date=>"2018-03-05", :value=>13},
                        {:date=>"2018-03-06", :value=>13},
                        {:date=>"2018-03-07", :value=>12},
                        {:date=>"2018-03-08", :value=>12},
                        {:date=>"2018-03-09", :value=>12},
                        {:date=>"2018-03-12", :value=>12},
                        {:date=>"2018-03-13", :value=>12},
                        {:date=>"2018-03-14", :value=>12},
                        {:date=>"2018-03-15", :value=>12},
                        {:date=>"2018-03-16", :value=>12},
                        {:date=>"2018-03-19", :value=>11.5},
                        {:date=>"2018-03-20", :value=>11.5},
                        {:date=>"2018-03-21", :value=>11.5},
                        {:date=>"2018-03-22", :value=>11.5},
                        {:date=>"2018-03-23", :value=>11.5},
                        {:date=>"2018-03-26", :value=>11.5},
                        {:date=>"2018-03-27", :value=>10.5},
                        {:date=>"2018-03-28", :value=>10.5},
                        {:date=>"2018-03-29", :value=>10.5},
                        {:date=>"2018-03-30", :value=>10.5}]
                     )
    end
  end
end
