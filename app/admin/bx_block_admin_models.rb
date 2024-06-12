ActiveAdmin.register BxBlockAdmin::Model , as: "Car Models"do
  menu parent: "Cars"

  permit_params :name, :body_type, :engine_type, :autopilot, :autopilot_type, :company_id, car_engine_type_ids: []
  
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
      f.input :company_id, :label => 'company', as: :select, collection: BxBlockAdmin::Company.all.map{|c| [c.name, c.id]}
      f.input :name
      f.input :body_type
      f.input :engine_type
      f.input :autopilot
      f.input :autopilot_type, input_html: {id: "autopilot_type"}
    end
    
    f.inputs "Engine Types" do
      f.input :car_engine_types, as: :select, collection: [["Select an engine type", nil]] + BxBlockAdmin::CarEngineType.all.map { |engine_type| [engine_type.name, engine_type.id] }, input_html: { multiple: false }
    end
    # f.inputs :engine_type, as: :select, collection: BxBlockAdmin::Model::TRANSMISSIONS
    f.actions
  end

  filter :name 
  filter :body_type 
  filter :autopilot 
  #filter :autopilot_type 
  #filter :company_id 
  filter :autopilot_type, as: :select, collection: {"No Driving Automation": 0, "Driver Assistance": 1, "Partial Driving Automation": 2, "Conditional Driving Automation": 3, "High Driving Automation": 4} 
  filter :company_id, as: :select, collection: BxBlockAdmin::Company.all.map{|c| [c.name, c.id]}

  filter :car_engine_type_ids
end