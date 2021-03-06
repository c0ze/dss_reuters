module DataScope
  class Config
    BASE_URI = "https://hosted.datascopeapi.reuters.com"
    LOG_LEVEL = ENV['DATA_SCOPE_LOG_LEVEL'] || 'INFO'
    DATA_SCOPE_USERNAME = ENV['DATA_SCOPE_USERNAME'] || ENV['DSS_USERNAME']
    DATA_SCOPE_PASSWORD = ENV['DATA_SCOPE_PASSWORD'] || ENV['DSS_PASSWORD']
  end

  class Session
    include HTTParty
    base_uri Config::BASE_URI

    attr_reader :context, :token, :logger

    def configured?
      !Config::DATA_SCOPE_USERNAME.nil? and !Config::DATA_SCOPE_PASSWORD.nil?
    end

    def not_configured_error
      @logger.error "dss_reuters gem not configured. you will not be able to fetch data from data scope API"
    end

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
            "Username" => Config::DATA_SCOPE_USERNAME,
            "Password" => Config::DATA_SCOPE_PASSWORD
          }
        }.to_json
      }
      if configured?
        resp = self.class.post login_path, options
        @token = resp["value"]
        @context = resp["@odata.context"]
        @logger.debug resp
      else
        not_configured_error
      end
    end
  end

  class User
    include HTTParty
    base_uri Config::BASE_URI

    def initialize(session)
      @session = session
      path = "/RestApi/v1/Users/Users(#{Config::DATA_SCOPE_USERNAME})"
      options = {
        headers: {
          "Prefer" => "respond-async",
          "Authorization" => "Token #{@session.token}"
        }
      }
      if session.configured?
        resp = self.class.get path, options
        @session.logger.debug resp
      else
        session.not_configured_error
      end
    end
  end

  class OnDemandExtract
    include HTTParty
    base_uri Config::BASE_URI
    attr_reader :result
    attr_accessor :status, :location

    def camelize(str)
      str.to_s.split('_').collect(&:capitalize).join
    end

    def self.init_with_location(session, location)
      ins = self.new(session)
      ins.status = :in_progress
      ins.location = location
      ins
    end

    def initialize(session, identifiers=nil, type=nil, fields=nil, condition=nil)
      @session = session
      @status = :init
      path = "/RestApi/v1/Extractions/ExtractWithNotes"

      if fields
        options = {
          headers: {
            "Prefer" => "respond-async; wait=5",
            "Content-Type" => "application/json; odata=minimalmetadata",
            "Authorization" => "Token #{@session.token}"
          },
          body: {
            "ExtractionRequest" => {
              "@odata.type" => "#{camelize(type)}ExtractionRequest",
              "ContentFieldNames" => fields,
              "IdentifierList" => {
                "@odata.type" => "InstrumentIdentifierList",
                "InstrumentIdentifiers" => identifiers,
                "ValidationOptions" => nil,
                "UseUserPreferencesForValidationOptions" => false
              },
              "Condition" => condition
            }
          }.to_json
        }
        if session.configured?
          resp = self.class.post path, options
          process_response(resp)
          @session.logger.debug resp
        else
          session.not_configured_error
        end
      end
    end

    def process_response(resp)
      @location = resp["location"]
      @result = resp
      @status = case resp["status"]
                when "InProgress"
                  :in_progress
                else
                  :completed
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
        if @session.configured?
          resp = self.class.get @location, options
          process_response(resp)
          @session.logger.debug @result
          @status
        else
          @session.not_configured_error
        end
      end
    end
  end

  class Api
    attr_reader :session

    def initialize
      @session = Session.new
    end

    def get_user
      @user = User.new(@session)
    end

    def extract_with_location(location)
      OnDemandExtract.init_with_location(@session, location)
    end

    def extract_with_isin(isin_code, type=:composite, fields=nil, condition=nil)
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
      OnDemandExtract.new(@session, identifiers, type, fields, condition)
    end

    def extract_with_ric(ric_code, type=:composite, fields=nil, condition=nil)
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
          "Identifier" => ric_code,
          "IdentifierType" => "Ric"
        }
      ]
      OnDemandExtract.new(@session, identifiers, type, fields, condition)
    end
  end
end
