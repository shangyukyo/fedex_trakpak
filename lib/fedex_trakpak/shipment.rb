require 'fedex_trakpak/credentials'
require 'fedex_trakpak/request/label'

module FedexTrakpak
  class Shipment

    def initialize(options={})
      @credentials = Credentials.new(options)
    end

    def label(options = {})
      Request::Label.new(@credentials, options).process_request
    end

    def track(options = {})
      Request::TrackingInformation.new(@credentials, options).process_request
    end

    # @param [Hash] package_id, A string with the tracking number to delete
    def delete(options = {})
      Request::Delete.new(@credentials, options).process_request
    end

  end
end
