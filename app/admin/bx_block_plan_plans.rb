ActiveAdmin.register BxBlockPlan::Plan, as: "Subscription Plans" do

  permit_params :name, :duration, :price, :details, :ad_count
  
  form do |f|
    f.inputs do
      f.input :name
      f.input :duration, as: :select, collection: BxBlockPlan::Plan.durations.keys
      f.input :price, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
      f.input :details, as: :string
      f.input :ad_count
    end
    # f.inputs do 
    #   input :ad_count
    # end          
    f.actions
  end

  show do |plan|
    h3 "Ad Count"
    plan.ad_count
    default_main_content
  end

  filter :name 
  filter :duration 
  filter :price
end