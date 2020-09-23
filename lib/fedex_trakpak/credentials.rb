require 'fedex_trakpak/helpers'

module FedexTrakpak
  class Credentials
    include Helpers
    attr_reader :api_key, :mode

    def initialize(options={})
      requires!(options, :api_key)
      @api_key = options[:api_key]
      @mode = options[:mode]
    end
  end
end