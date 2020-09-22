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

      SERVICE_TYPES = %w(CBEC CBECL)


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

      def add_service(xml)
        xml.Service @service_type
      end

      def add_pieces(xml)
        xml.Pieces 1
      end

      def add_dimension(xml)
        puts @package.inspect
        xml.Weight @package[:weight]
        xml.WeightUnit @package[:weight_unit]
        xml.Length @package[:length]
        xml.Width @package[:width]
        xml.Height @package[:height]
        xml.DimUnit 'in'
        xml.DescriptionOfGoods @package[:description_of_goods]
        xml.Value @package[:shipment_value]
        xml.Currency @package[:shipment_currency]
        xml.Terms @package[:terms]
      end
    end
  end
end