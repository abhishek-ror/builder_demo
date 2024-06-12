ActiveAdmin.register BxBlockRateCard::DocumentationCharge, as: "Documentation Charges" do
  menu parent: "Rate Cards",:priority => 2

  config.per_page = 10
  active_admin_import   validate: true
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :country, :region, :price
  #
  # or
  #
  # permit_params do
  #   permitted = [:country, :region, :price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index download_links: [:csv] do
    selectable_column
    id_column
    column :country
    column :region
    column "Price($)", :price

    actions
  end

  csv do
    column :country
    column :region
    column :price
  end

  form do |f|
    f.inputs do
      f.input :country
      f.input :region,as: :select, collection: BxBlockAdmin::Region.all.map{|t| [t.name, t.name] }
      f.input :price, label: 'Price($)', as: :string, input_html: { min: 0, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
    end
      
    f.actions
  end
  action_item :download_csv_sample, only: :import do
    link_to('Download Csv Sample',download_csv_sample_admin_documentation_charges_path)
  end

  collection_action :download_csv_sample, :method => :get do
    csv_headers = ["country", "region", "price"]
    rawcsv = CSV.generate do |csv|
      csv << csv_headers     
    end
    send_data(rawcsv, :type => 'text/csv charset=utf-8; header=present', :filename => "documentation_charges_sample.csv") and return
  end

  filter :country
  filter :region
  

  
end
