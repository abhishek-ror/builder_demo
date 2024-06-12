ActiveAdmin.register BxBlockAdmin::Trim, as: "Model Trims" do
  menu parent: "Cars"

  permit_params :name, :model_id
  
  filter :name
  filter :model
end