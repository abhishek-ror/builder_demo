ActiveAdmin.register BxBlockRateCard::ShippingCharge, as: "Shipping Charges" do
  menu parent: "Rate Cards",:priority => 1

  config.per_page = 10
  active_admin_import   validate: true
  
  permit_params :destination_country, :destination_port, :price, :in_transit, :source_country

  index download_links: [:csv] do
    selectable_column
    id_column
    column :source_country
    column :destination_country
    column :destination_port
    column "Price($)", :price
    column :in_transit

    actions
  end

  form do |f|
    f.inputs do
      f.input :source_country
      f.input :destination_country
      f.input :destination_port
      f.input :price, label: 'Price($)', as: :string, input_html: { min: 0, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
      f.input :in_transit
    end
      
    f.actions
  end

  show do
    attributes_table do
      row :source_country
      row :destination_country
      row :destination_port
      row :price
      row :in_transit
    end
  end

  csv do
    column :source_country
    column :destination_country
    column :destination_port
    column :price
    column :in_transit  
  end

  action_item :download_csv_sample, only: :import do
    link_to('Download Csv Sample',download_csv_sample_admin_shipping_charges_path)
  end

  collection_action :download_csv_sample, :method => :get do
    csv_headers = ["source_country", "destination_country", "destination_port", "price","in_transit"]
    rawcsv = CSV.generate do |csv|
      csv << csv_headers     
    end
    send_data(rawcsv, :type => 'text/csv charset=utf-8; header=present', :filename => "shipping_charges_sample.csv") and return
  end

  filter :source_country
  filter :destination_country
  filter :destination_port  
end