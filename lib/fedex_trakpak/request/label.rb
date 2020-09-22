require 'fedex_trakpak/request/base'
require 'fileutils'

module FedexTrakpak
  module Request
    class Label < Base

      def initialize(credentials, options={})
        requires!(options, :shipper, :recipient, :package)
        @credentials = credentials
        @shipper, @recipient, @package, @service_type, @customs_items = options[:shipper], options[:recipient], options[:package], options[:service_type], options[:customs_items]                

        if options[:http_proxy]
          self.class.http_proxy options[:http_proxy][:host], options[:http_proxy][:port]
        end
      end

      def process_request        
        puts build_xml

        # api_response = self.class.post api_url, :body => build_xml
        # puts api_response if @debug
        # response = parse_response(api_response)

        # # File.open('/Users/macbookpro/Workspaces/fedex_response', 'w+'){|f| f.puts response}
        # if success?(response)
        #   success_response(api_response, response)
        # else
        #   failure_response(api_response, response)
        # end
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
            end
          end    
        end
        xml = builder.doc.root.to_xml        
        xml
      end

    end
  end
end