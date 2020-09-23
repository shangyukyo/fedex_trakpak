require 'base64'
require 'pathname'

module FedexTrakpak
  class Label
    attr_accessor :tracking_number, :track_url, :carrier_tracking_number, :carrier_track_url


    def initialize(label_details = {})
      @tracking_number = label_details[:create_shipment_response][:shipment][:tracking_number]
      @track_url = label_details[:create_shipment_response][:shipment][:tracking_url]
      @carrier_tracking_number = label_details[:create_shipment_response][:shipment][:carrier_tracking_number]
      @carrier_track_url = label_details[:create_shipment_response][:shipment][:carrier_tracking_url]
      file_path = label_details[:file_name]
      format = label_details[:format]

      if format.downcase == 'pdf'
        filename_ary = []

        image_1 = label_details[:create_shipment_response][:shipment][:label_image]
        image_2 = label_details[:create_shipment_response][:shipment][:label_image_2]

        [image_1, image_2].each_with_index do |img, index|
          next if img.blank?
          name = "#{@tracking_number}_#{index}.#{format.downcase}"        
          decoded_img = Base64.decode64(img) 
          filename = [file_path, name].join('_')
          filename_ary << filename   

          save(decoded_img, filename)            
        end

        pdf = CombinePDF.new
        filename_ary.each do |file|
          pdf << CombinePDF.load(file)
        end
        pdf.save "#{file_path}_#{@tracking_number}.#{format.downcase}"
      end
    end


    def save(image, filename)
      File.open(filename, 'wb') do |f|
        f.write(image)
      end
    end

  end
end