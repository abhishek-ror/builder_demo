ActiveAdmin.register BxBlockRateCard::DestinationHandling,as: "Destination Handling" do
  menu parent: "Rate Cards"
  config.per_page = 10
  active_admin_import   validate: true
  

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :destination_country, :unloading, :customs_clearance, :storage
  #
  # or
  #
  # permit_params do
  #   permitted = [:source_country, :destination_country, :unloading, :customs_clearance, :storage]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index download_links: [:csv] do
    selectable_column
    id_column
    column :destination_country
    column "Unloading($)", :unloading
    column "Customs Clearance($)", :customs_clearance
    column "Storage($)", :storage

    actions
  end

  form do |f|
    f.inputs do
      f.input :destination_country
      f.input :unloading, label: 'Unloading($)', as: :string, input_html: { min: 0, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
      f.input :customs_clearance, label: 'Customs Clearance($)', as: :string, input_html: { min: 0, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
      f.input :storage, label: 'Storage($)', as: :string, input_html: { min: 0, oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");' }
    end
      
    f.actions
  end

  csv do
    column :destination_country
    column :unloading
    column :customs_clearance
    column :storage
  end

  action_item :download_csv_sample, only: :import do
    link_to('Download Csv Sample',download_csv_sample_admin_destination_handlings_path)
  end

  collection_action :download_csv_sample, :method => :get do
    csv_headers = ["destination_country", "unloading", "customs_clearance","storage"]
    rawcsv = CSV.generate do |csv|
      csv << csv_headers     
    end
    send_data(rawcsv, :type => 'text/csv charset=utf-8; header=present', :filename => "destination_handling_sample.csv") and return
  end

  filter :source_country
  filter :destination_country

end
