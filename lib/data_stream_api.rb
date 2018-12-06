module DataStream
  class Config
    BASE_URI = "http://product.datastream.com"
    LOG_LEVEL = ENV['DATA_STREAM_LOG_LEVEL'] || 'INFO'
    DATA_STREAM_USERNAME = ENV['DATA_STREAM_USERNAME']
    DATA_STREAM_PASSWORD = ENV['DATA_STREAM_PASSWORD']
  end

  class Session
    include HTTParty
    include DssUtilities
    base_uri Config::BASE_URI

    attr_reader :context, :token, :logger

    def configured?
      !Config::DATA_STREAM_USERNAME.nil? and !Config::DATA_STREAM_PASSWORD.nil?
    end

    def not_configured_error
      @logger.error "dss_reuters gem not configured. you will not be able to fetch data from data stream API"
    end

    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = Config::LOG_LEVEL
      login_path = "/DSWSClient/V1/DSService.svc/rest/Token"
      options = {
        query: {
          "UserName" => Config::DATA_STREAM_USERNAME,
          "Password" => Config::DATA_STREAM_PASSWORD
        }
      }
      if configured?
        resp = self.class.get login_path, options
        @token = resp["TokenValue"]
        @expiry = parseDate(resp["TokenExpiry"])
        @logger.debug resp
      else
        not_configured_error
      end
    end
  end

  class Stream
    include HTTParty
    base_uri Config::BASE_URI
    attr_reader :result

    def initialize(session, instrument, date)
      @session = session
      path = "/DswsClient/V1/DSService.svc/rest/GetData"

      options = {
        headers: {
          "Content-Type" => "application/json"
        },
        body: {
          "DataRequest" => {
            "Date" => date,
            "Instrument" => instrument,
            "Tag" => nil
          },
          "Properties" => nil,
          "TokenValue" => @session.token
        }.to_json
      }

      if session.configured?
        @result = self.class.post path, options
        @session.logger.debug @result
      else
        session.not_configured_error
      end
    end
  end

  class Api
    attr_reader :session
    include DssUtilities
    def initialize
      @session = Session.new
    end

    def stream(value, date_start, date_end, options={})
      date = {
        "End" => date_end,
        "Frequency" => "",
        "Kind" => 1,
        "Start" => date_start
      }

      instrument = {
        "Properties" => [
          {
            "Key" => "IsSymbolSet",
            "Value" => true
          }
        ],
        "Value" => value
      }
      stream = Stream.new @session, instrument, date
      stream.result["DataResponse"]["Dates"].each_with_index.map do |date, i|
        { date: parseDate(date, options),
          value: stream.result["DataResponse"]["DataTypeValues"][0]["SymbolValues"][0]["Value"][i]
        }
      end
    end

    def ric_stream(ric, date_start, date_end, options={})
      stream "<#{ric}>", date_start, date_end, options
    end

    def isin_stream(isin, date_start, date_end, options={})
      stream isin, date_start, date_end, options
    end
  end
end
