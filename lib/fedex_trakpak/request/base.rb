require 'httparty'
require 'nokogiri'
require 'fedex_trakpak/helpers'

module FedexTrakpak
  module Request
    class Base
      include Helpers
      include HTTParty
      format :xml
      attr_accessor :debug

      TEST_URL = "https://trakpak.co.uk/API/?version=3.0&testMode=1"

      # Fedex Production URL
      PRODUCTION_URL = "https://trakpak.co.uk/API/?version=3.0"

      SERVICE_TYPES = %w(CBEC)


      def process_request
        raise NotImplementedError, "Override process_request in subclass"
      end


      def api_url
        @credentials.mode == "production" ? PRODUCTION_URL : TEST_URL
      end

      # Build xml Fedex Web Service request
      # Implemented by each subclass
      def build_xml
        raise NotImplementedError, "Override build_xml in subclass"
      end
  
      private

      def add_credentials(xml)
        xml.Apikey @credentials.api_key
      end

      def add_label_type(xml)
        xml.LabelType 'TrakPak'
      end

      def add_label_format(xml)
        xml.LabelFormat 'PDF'
      end

      def add_shipper(xml)
        xml.Shipper do 
          xml.ContactName @shipper[:name]
          xml.Company @shipper[:company]
          xml.Address1 @shipper[:address_1]
          xml.Address2 @shipper[:address_2]
          xml.City @shipper[:city]
          xml.Country @shipper[:country_code]
          xml.Zip @shipper[:postal_code]
          xml.CountryCode @shipper[:country_code]
          xml.Phone @shipper[:phone_number]
          xml.Email @shipper[:email]
          xml.Vat ''
        end
      end

      def add_consignee(xml)
        xml.Consignee do 
          xml.ContactName @recipient[:name]
          xml.Company @recipient[:company]
          xml.Address1 @recipient[:address_1]
          xml.Address2 @recipient[:address_2]
          xml.City @recipient[:city]
          xml.Country @recipient[:country_code]
          xml.Zip @recipient[:postal_code]
          xml.CountryCode @recipient[:country_code]
          xml.Phone @recipient[:phone_number]
          xml.Email @recipient[:email]
          xml.Vat ''
        end
      end

      def add_service(xml)
        xml.Service @service_type
      end

      def add_pieces(xml)
        xml.Pieces 1
      end

      def add_terms(xml)
        xml.Terms @package[:terms]
      end

      def add_dimension(xml)        
        xml.Weight @package[:weight]
        xml.WeightUnit @package[:weight_unit]
        xml.Length @package[:length]
        xml.Width @package[:width]
        xml.Height @package[:height]
        xml.DimUnit 'in'
        xml.DescriptionOfGoods @package[:description_of_goods]
        xml.Value @package[:shipment_value]
        xml.Currency @package[:shipment_currency]        
      end

      def add_items(xml)
        @package[:items].each do |item|         
          xml.Item do 
            xml.Description item[:description]
            xml.SkuCode item[:sku]
            xml.HsCode item[:hs_code]
            xml.CountryOfOrigin item[:origin_country]
            xml.PurchaseUrl item[:purchase_url]
            xml.Quantity item[:quantity]
            xml.Value item[:price]
          end
        end
      end

      # Parse response, convert keys to underscore symbols
      def parse_response(response)
        response = sanitize_response_keys(response.parsed_response)
      end

      # Recursively sanitizes the response object by cleaning up any hash keys.
      def sanitize_response_keys(response)
        if response.is_a?(Hash)
          response.inject({}) { |result, (key, value)| result[underscorize(key).to_sym] = sanitize_response_keys(value); result }
        elsif response.is_a?(Array)
          response.collect { |result| sanitize_response_keys(result) }
        else
          response
        end
      end

      
    end
  end
end