module Tracker
  class Base < ActiveResource::Base
    cattr_accessor :site_base, :current_user
    self.site_base = "https://www.pivotaltracker.com/services/v3"
    self.format = ActiveResource::Formats::XmlFormat
    self.logger = Logger.new(STDOUT)
    self.timeout = 30

    def self.headers
      creds = Tracker::Base.current_user || User.first
      creds ? {"X-TrackerToken" => creds.tracker_token} : {}
    end
  end
end
