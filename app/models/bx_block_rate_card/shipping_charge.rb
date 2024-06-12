module BxBlockRateCard
  class ShippingCharge < ApplicationRecord
  	self.table_name = :shipping_charges
    # validates :source_country,:destination_country, :destination_port, :uniqueness => {:scope => [:destination_port],:message => "Duplicate data present.."}
    validates :destination_port, :uniqueness => {:scope => [:destination_country, :source_country], :message => "Data already present.."}
    # validates :source_country, :destination_country, :destination_port, presence: true, format: { with: /\A([A-Z]{1}[a-z]*\s*)*\z/, message: "Only String value is allow and first character should be capital."}
    validates :source_country, :destination_country, :destination_port, presence: true, format: { with: /\A\p{Lu}.*\z/, message: "Only string value is allowed, and the first character should be capital." }
    validates :price, :in_transit, presence: true, numericality: { only_numeric: true, greater_than_or_equal_to: 0 }

    #  def self.import(file)
    #   CSV.foreach(file.path, headers: true) do |row|
    #     data_hash = row.to_hash
    #     data = find_or_create_by!(source_country: data_hash['source_country'],destination_port: data_hash[:destination_port],destination_country: data_hash['destination_country'])
    #     data.update(data_hash)
    #   end
    # end

    # def self.import(file)
    #   spreadsheet = open_spreadsheet(file)
    #   header = spreadsheet.row(1)
    #   (2..spreadsheet.last_row).each do |i|
    #     row = Hash[[header, spreadsheet.row(i)].transpose]
    #     data = find_or_create_by!(source_country: row['source_country'],destination_port: row[:destination_port],destination_country: row['destination_country'])
    #     data.update(row)
    #   end
    # end

    # def self.open_spreadsheet(file)
    #   case  File.extname(file.original_filename)
    #   when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
    #   when ".xls" then Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    #   when ".xlsx" then Roo::ExcelX.new(file.path, nil, :ignore)
    #   else raise "unknown file type: #{file.original_filename}"
    #   end
    # end

    # def self.export_to_csv(data,fields = column_names,options = {})
    #   charges = data
    #   CSV.generate(options) do |csv|
    #     csv << fields
    #     if charges.present?
    #       charges.each do |charge|
    #         csv << charge.attributes.values_at(*fields)
    #       end
    #     end
    #   end
    # end
    
  end
end
