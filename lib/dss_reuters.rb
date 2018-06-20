require "logger"
require "httparty"
require "dss_reuters/version"

module DssReuters
  class Config
    BASE_URI = "https://hosted.datascopeapi.reuters.com"
    DSS_USERNAME = ENV.fetch('DSS_USERNAME')
    DSS_PASSWORD = ENV.fetch('DSS_PASSWORD')
    LOG_LEVEL = ENV['DSS_LOG_LEVEL'] || 'INFO'
  end

  class Session
    include HTTParty
    base_uri Config::BASE_URI

    attr_reader :context, :token, :logger

    def initialize
      @logger = ::Logger.new(STDOUT)
      @logger.level = Config::LOG_LEVEL
      login_path = "/RestApi/v1/Authentication/RequestToken"
      options = {
        headers: {
          "Prefer" => "respond-async",
          "Content-Type" => "application/json; odata=minimalmetadata"
        },
        body: {
          "Credentials" =>{
            "Username" => Config::DSS_USERNAME,
            "Password" => Config::DSS_PASSWORD
          }
        }.to_json
      }
      resp = self.class.post login_path, options
      @token = resp["value"]
      @context = resp["@odata.context"]
      @logger.debug resp
    end
  end

  class User
    include HTTParty
    base_uri Config::BASE_URI

    def initialize(session)
      @session = session
      path = "/RestApi/v1/Users/Users(#{Config::DSS_USERNAME})"
      options = {
        headers: {
          "Prefer" => "respond-async",
          "Authorization" => "Token #{@session.token}"
        }
      }
      resp = self.class.get path, options
      @session.logger.debug resp
    end
  end

  class OnDemandExtract
    include HTTParty
    base_uri Config::BASE_URI
    attr_reader :result, :status

    def camelize(str)
      str.to_s.split('_').collect(&:capitalize).join
    end

    def initialize(session, fields, identifiers, type)
      @session = session
      @status = :init
      path = "/RestApi/v1/Extractions/ExtractWithNotes"
      options = {
        headers: {
          "Prefer" => "respond-async; wait=5",
          "Content-Type" => "application/json; odata=minimalmetadata",
          "Authorization" => "Token #{@session.token}"
        },
        body: {
          "ExtractionRequest" => {
            "@odata.type" => "#ThomsonReuters.Dss.Api.Extractions.ExtractionRequests.#{camelize(type)}ExtractionRequest",
            "ContentFieldNames" => fields,
            "IdentifierList" => {
              "@odata.type" => "#ThomsonReuters.Dss.Api.Extractions.ExtractionRequests.InstrumentIdentifierList",
              "InstrumentIdentifiers" => identifiers,
              "ValidationOptions" => nil,
              "UseUserPreferencesForValidationOptions" => false
            },
            "Condition" => nil
          }
        }.to_json
      }
      resp = self.class.post path, options
      if check_status(resp)
        @location = resp["location"]
      end
      pp resp
      @session.logger.debug resp
    end

    def check_status(resp)
      if resp["status"] == "InProgress"
        @status = :in_progress
      else
        @status = :complete
      end
    end

    def get_result
      if @status == :in_progress
        options = {
          headers: {
            "Prefer" => "respond-async; wait=5",
            "Authorization" => "Token #{@session.token}"
          }
        }
        @result = self.class.get @location, options
        check_status @result
        @session.logger.debug @result
      end
    end
  end

  class Api
    def initialize
      @session = Session.new
    end

    def get_user
      @user = User.new(@session)
    end

    def extract_with_isin(isin_code, fields=nil, type=:composite)
      fields ||= [
        "Close Price",
        "Contributor Code Description",
        "Currency Code Description",
        "Dividend Yield",
        "Main Index",
        "Market Capitalization",
        "Market Capitalization - Local Currency",
        "Percent Change - Close Price - 1 Day",
        "Universal Close Price Date"
      ]
      identifiers = [
        {
          "Identifier" => isin_code,
         "IdentifierType" => "Isin"
        }
      ]
      OnDemandExtract.new(@session, fields, identifiers, type)
    end
  end
end
