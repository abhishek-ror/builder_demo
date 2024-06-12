ActiveAdmin.register BxBlockAdmin::GlobalOffice, as: "Global Offices" do

  permit_params :address_line_1, :address_line_2, :city_id

  filter :city_id, as: :select, collection: BxBlockAdmin::City.where(id: BxBlockAdmin::GlobalOffice.all.pluck(:city_id)&.uniq).map{|c| [c.name, c.id]}

end