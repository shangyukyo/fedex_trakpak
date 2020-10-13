module FedexTrakpak
  module Request
    class Rate < Base

      def initialize(credentials, options={})
        requires!(options, :shipper, :recipient, :package)
        @credentials = credentials
        @shipper, @recipient, @package, @service_type, @customs_items, @filename = options[:shipper], options[:recipient], options[:package], options[:service_type], options[:customs_items], options[:filename]        
      end

      def process_request
        results = []
        if @package[:weight_unit].downcase =~ /lb/
          service_types = if @service_type.blank? 
            SERVICE_TYPES
          else
            [@service_type]
          end

          service_types.each do |service|            
            fees = FedexTrakpak::Data::Rates::SERVICE_RATES[service]            
            next if fees.blank?                     
            results << {
              service_type: service,
              total_net_charge: fees[@recipient[:country_code]][@package[:weight].ceil]
            }
          end          
        else
          raise RateError
        end
        results
      end

    end
   
  end
end