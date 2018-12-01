require "dotenv/load"
require "logger"
require "httparty"
require "dss_reuters/version"

module DataStream
  class Config
    BASE_URI = "http://product.datastream.com"
    LOG_LEVEL = ENV['DATA_STREAM_LOG_LEVEL'] || 'INFO'
    DATA_STREAM_USERNAME = ENV['DATA_STREAM_USERNAME']
    DATA_STREAM_PASSWORD = ENV['DATA_STREAM_PASSWORD']
  end

  class Session
    include HTTParty
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
        @expiry = Time.at(resp["TokenExpiry"].split("(")[1].split(")")[0].to_i/1000)
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

    def initialize(session, types, date, instrument)
      @session = session
      path = "/DswsClient/V1/DSService.svc/rest/GetData"

      options = {
        headers: {
          "Content-Type" => "application/json"
        },
        body: {
          "DataRequest" => {
            "DataTypes" => types,
            "Date" => date,
            "Instrument" => instrument,
            "Tag" => nil
          },
          "Properties" => nil,
          "TokenValue" => @session.token
        }.to_json
      }

      if session.configured?
        resp = self.class.post path, options
        binding.pry
        @session.logger.debug resp
      else
        session.not_configured_error
      end
    end
  end

  class Api
    attr_reader :session

    def initialize
      @session = Session.new
    end

    def stream(id_type=nil, id_value=nil, date_start=nil, date_end=nil)
      # types = [
      #   {
      #     "Properties" => nil,
      #     "Value" => "PL"
      #   },
      #   {
      #     "Properties" => nil,
      #     "Value" => "PH"
      #   }
      # ]
      # date = {
      #   "End" => "-20D",
      #   "Frequency" => "D",
      #   "Kind" => 1,
      #   "Start" => "-30D"
      # }
      # instrument = {
      #   "Properties" => nil,
      #   "Value" => "VOD"
      # }

      types = [
        {
          "Properties" => nil,
          "Value" => ".TRXFLDAUTFIN"
        }
      ]

      date = {
        "End" => "2018-04-01",
        "Frequency" => "",
        "Kind" => 1,
        "Start" => "2018-01-01"
      }

      instrument = {
        "Properties" => [
          {
            "Key" => "IsExpression",
            "Value" => true
          }
        ],
        "Value" => "RIC"
      }

      Stream.new @session, types, date, instrument
    end
  end
end
