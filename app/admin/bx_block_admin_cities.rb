ActiveAdmin.register BxBlockAdmin::City, as: "Cities" do
  menu parent: "Location"
  permit_params :name, :state_id, :zipcode
  
  filter :name 
  filter :state
  filter :zipcode
end