require 'fedex_trakpak/request/base'

module FedexTrakpak
  module Request
    class Track < Base

      attr_reader :tracking_number

      def initialize(credentials, options={})        
        requires!(options, :tracking_number)
        @tracking_number  = options[:tracking_number]        
        @credentials  = credentials
      end

      def process_request    
        api_response = self.class.post(api_url, :body => build_xml)                
        response = parse_response(api_response)              
        puts response.inspect
        if success?(response)
          success_response(api_response, response)
        else
          failure_response(api_response, response)
        end
      end

      private

      # Build xml Fedex Web Service request
      def build_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.TrackShipment do 
            add_credentials(xml)
            xml.Shipment do 
              xml.TrackingNumber @tracking_number
            end
          end
        end
        builder.doc.root.to_xml
      end

      # Successful request
      def success?(response)
        response[:cancel_shipment_response][:error] == "0"
      end

      def success_response(api_response, response)        
        response[:track_shipment_response][:shipment][:events]
      end          

      def failure_response(api_response, response)
        error_message = response[:cancel_shipment_response][:error]
        raise RateError, error_message
      end 

    end
  end
end
