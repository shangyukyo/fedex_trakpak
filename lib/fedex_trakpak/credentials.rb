require 'fedex_trakpak/helpers'

module FedexTrakpak
  class Credentials
    include Helpers
    attr_reader :api_key

    def initialize(options={})
      requires!(options, :api_key)
      @api_key = options[:api_key]
    end
  end
end