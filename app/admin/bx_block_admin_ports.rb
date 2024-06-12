ActiveAdmin.register BxBlockAdmin::Port, as: "Add Port" do

  permit_params do
    permitted = [:port_name, :country_id]
    permitted << :other if params[:action] == 'create' 
    permitted
  end
  
end
