ActiveAdmin.register BxBlockRateCard::InspectionCharge, as: "Inspection Charges" do
  menu parent: "Rate Cards",:priority => 0

  config.per_page = 10
  active_admin_import   validate: true
  permit_params :country, :region, :price

  index download_links: [:csv] do
    selectable_column
    id_column
    column :country
    column :region
    column "Price($)", :price

    actions
  end

  form do |f|
    f.inputs do
      f.input :country
      f.input :region,as: :select, collection: BxBlockAdmin::Region.all.map{|t| [t.name, t.name] }
      f.input :price, label: 'Price($)', as: :string, input_html: { min: 0, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
    end
      
    f.actions
  end

  csv do
    column :country
    column :region
    column :price
  end
  
  action_item :download_csv_sample, only: :import do
    link_to('Download Csv Sample',download_csv_sample_admin_inspection_charges_path)
  end

  collection_action :download_csv_sample, :method => :get do
    csv_headers = ["country", "region", "price"]
    rawcsv = CSV.generate do |csv|
      csv << csv_headers     
    end
    send_data(rawcsv, :type => 'text/csv charset=utf-8; header=present', :filename => "inspection_charges_sample.csv") and return
  end

  filter :country
  filter :region 
end