ActiveAdmin.register BxBlockAdmin::SellerType, as: "Seller Type" do
  menu parent: "Cars"
  permit_params :name

  form do |f|
    f.inputs do 
      f.input :name
    end
    f.actions
  end
  
  filter :name
end