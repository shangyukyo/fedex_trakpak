require 'fedex_trakpak/request/base'
require 'fedex_trakpak/label'
require 'fileutils'

module FedexTrakpak
  module Request
    class Label < Base

      def initialize(credentials, options={})
        requires!(options, :shipper, :recipient, :package)
        @credentials = credentials
        @shipper, @recipient, @package, @service_type, @customs_items, @filename = options[:shipper], options[:recipient], options[:package], options[:service_type], options[:customs_items], options[:filename]
      end

      def process_request        
        puts build_xml
        api_response = self.class.post api_url, :body => build_xml        
        response = parse_response(api_response)

        if success?(response)
          success_response(api_response, response)
        else
          failure_response(api_response, response)
        end
      end


      private

      def build_xml
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.CreateShipment do 
            add_credentials(xml)
            xml.Shipment do 
              add_label_type(xml)
              add_label_format(xml)
              add_shipper(xml)  
              add_consignee(xml)
              add_service(xml)
              add_pieces(xml)              
              add_dimension(xml)                            
              add_terms(xml)
              add_items(xml)
            end
          end    
        end
        xml = builder.doc.root.to_xml        
        xml
      end  

      def success?(response)
        response[:create_shipment_response][:error_level] == "0"
      end

      def success_response(api_response, response)
        label_details = response.merge!({
          :format => response[:create_shipment_response][:shipment][:label_format],
          :file_name => @filename
        })

        FedexTrakpak::Label.new label_details
      end    

      
      def failure_response(api_response, response)
        error_message = response[:create_shipment_response][:Error]
        raise RateError, error_message
      end 


    end
   
  end
end