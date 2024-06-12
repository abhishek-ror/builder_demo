ActiveAdmin.register BxBlockAdmin::State, as: "States" do
  menu parent: "Location"
  permit_params :name, :country_id 

  filter :name 
end