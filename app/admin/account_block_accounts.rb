ActiveAdmin.register AccountBlock::Account, as: "Accounts" do
  permit_params :full_phone_number, :country_code, :phone_number, :email, :activated,  :password_digest,:user_type,:company_name, :country,:password,:password_confirmation, :fcm_device_token, user_subscriptions_attributes: [:id, :plan_id, :status, :start_date, :expiry_date, :_destroy]

  actions :all, :except => [:new, :destroy]
  config.per_page = 10

  scope :all, default: true
  scope("Individual") { |scope| scope.where(user_type: "individual",activated: true) }
  scope("Business") { |scope| scope.where(user_type: "business",activated: true) }
  scope("Inspector") { |scope| scope.where(user_type: "inspector",activated: true) }

  csv do
    column :full_name
    column :company_name
    column :email
    column :password_digest
    column :country_code
    column :phone_number
    column :full_phone_number
    column :country
    column :user_type
    column :activated
    column :type
    column :role_id, humanize_name: false
    column :stripe_id, humanize_name: false
    column :is_paid
    column :platform
  end

  index download_links: [:csv] do
    selectable_column
    id_column
    column :full_name
    column :company_name
    column :email
    column :country_code
    column :phone_number
    column :full_phone_number
    column :country
    column :user_type
    column :activated
    column :type
    column :role_id, humanize_name: false
    column :stripe_id, humanize_name: false
    column :is_paid
    column :platform
    actions do |account|
      link_to "Delete", remove_admin_account_path(account),
        method: :delete,
        data: { confirm: 'if you delete this account your all record will be deleted' }, :class => "delete_link member_link"
    end
  end

  filter :full_name
  filter :company_name
  filter :full_phone_number
  filter :country
  filter :email
  filter :activated 
  filter :is_paid

  show do
    attributes_table do
      row :full_name if accounts.user_type == "inspector" || accounts.user_type == "individual"
      row :company_name if accounts.user_type == "business"
      row :email
      row :country_code
      row :phone_number
      row :full_phone_number
      row :country
      row :user_type
      row :activated
      row :type
      row :role_id
      row :gender
      row :date_of_birth
      row :age
      row :is_paid
      row :platform
      row :device_id
      row :fcm_device_token
      row :docs do |ad|
       ul do
        ad.docs.each do |doc|
          li do 
            # link_to(doc.filename,rails_blob_path(doc,disposition: "attachment"))
            link_to(doc.filename,doc.blob.service_url)
          end
        end
       end
      end
    end
  end

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
       f.input :user_type, :as => :select, :collection => (['individual','business','inspector'])
      f.input :company_name if f.object.user_type == "business"
      f.input :full_name if f.object.user_type == "inspector" || f.object.user_type == "individual"
      f.input :country_code, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 5 }
      f.input :phone_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9]/g, "");', maxlength: 20 }
      f.input :full_phone_number, as: :string, input_html: { oninput: 'this.value = this.value.replace(/[^0-9+]/g, "");', maxlength: 20 }
      f.input :country
      f.input :email
      f.input :fcm_device_token
      f.input :activated  
    end
    f.inputs "Subscription Plans" do
      f.has_many :user_subscriptions, heading: false , allow_destroy: true do |cd|
        cd.input :plan
        cd.input :start_date
        cd.input :expiry_date
        cd.input :status
      end
    end
    f.actions
  end

  member_action :remove, method: :delete do
    account = AccountBlock::Account.find(params[:id])
    account.destroy
    flash[:notice] = 'Account was successfully destroyed.'
    redirect_to admin_accounts_path
  end

end