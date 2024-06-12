ActiveAdmin.register BxBlockAdmin::Feature, as: "Features" do
  menu parent: "Cars"

  permit_params :name
  
  filter :name
end
