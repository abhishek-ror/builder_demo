ActiveAdmin.register BxBlockAdmin::RegionalSpec, as: "Regional Specs" do
  menu parent: "Cars"

  permit_params :name  
  filter :name
end