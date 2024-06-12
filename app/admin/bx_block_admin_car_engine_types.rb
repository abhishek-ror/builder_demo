ActiveAdmin.register BxBlockAdmin::CarEngineType, as: "Engine Type" do
  menu parent: "Cars"

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :engine_type
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.inputs do 
      f.input :name
      f.input :engine_type, as: :select, collection: ['Transmission Type', 'Fuel Type']
    end

    # f.inputs :engine_type, as: :select, collection: BxBlockAdmin::Model::TRANSMISSIONS
    f.actions
  end

  filter :name
  filter :engine_type
  filter :models
  
  
end
