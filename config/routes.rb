Rails.application.routes.draw do
  get "/healthcheck", to: proc { [200, {}, ["Ok"]] }
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

  namespace :account_block do
    resource :accounts, only: [:index, :create]
    # post :send_otp_to_admin, controller: "accounts"
    namespace :accounts do 
      post :send_otp_to_admin_email
      get :activate_account
      get :get_term_and_condition
      patch :update_term_and_condition
      delete :delete_account
      get :delete_account_with_id
      resource :sms_confirmations, only: [:create]  
      resource :otp_confirmations, only: [:create]
      resource :passwords, only: [:create] do
        collection do 
          get :user_one_time_password 
        end
      end  
      resource :resend_email_validations, only: [:create]  
      resource :country_code_and_flags, only: [:show] do 
        collection do 
          get :get_country_list 
        end
      end
    end
  end

  namespace :bx_block_login do
    resources :logins, only: [:create]
    resource :logouts, only: [:destroy]
  end

  namespace :bx_block_favourites do
    resources :favourites, only: [:create, :index, :destroy]
  end
  namespace :bx_block_forgot_password do
    resource :otps, only: [:create]
    resource :otp_confirmations, only: [:create]
    resource :passwords, only: [:create]
    resource :email_validations, only: [:create]
  end
  
  namespace :bx_block_profile do 
    resource :profiles, only: [:create, :index, :show] do 
      collection do 
        put :update_profile
        get :user_profiles
      end
    end
  end

  namespace :bx_block_admin do 
    get :global_offices, controller: "contents"
    get :get_regional_specs, controller: "contents"
    get :terms_and_conditions, controller: "contents"
    get :flash_screens, controller: "contents"
    get :banner_images, controller: "contents"
    post :contact_us, controller: "contents"
    get :regions, controller: "contents"
    get :make_year_list, controller: "contents"
    get :companies_by_make_year, controller: "contents"
    get :all_companies_list, controller: "contents"
    get :car_price_list, controller: "contents"
    get :subscription_plans, controller: "contents"
    get '/all_regions/:region_id/countries', controller: "contents", action: "countries", as: '/all_countries'
    get '/all_countries/:country_id/states',  controller: "contents", action: "states", as: '/all_states'
    get '/all_states/:state_id/cities',  controller: "contents", action: "cities", as: '/all_cities'
    get '/companies', controller: "contents", action: "companies", as: '/all_companies'
    get '/all_companies/:company_id/models',  controller: "contents", action: "models", as: '/all_models'
    get '/all_models/:model_id/trims',  controller: "contents", action: "trims", as: '/all_trims'
  end

  namespace :bx_block_address do 
    resource :addresses, only: [:create, :update, :index, :show]
  end

  namespace :bx_block_posts do 
    resources :car_ads do
      put :verify_otp_to_post, on: :member
      get :resend_otp, on: :member
      collection do
        get :query_data
        get :search
        get :search_cars_by_brand
        get :car_search
        get :all_cars
        get :my_ads
        put :status_update
        get :location_list
        get :make_list
        get :model_list
        get :trim_list
        get :year_list
        get :regional_spec_list
        get :body_type_list
        get :engine_type_list
        get :body_color_list
        get :horse_power_list
        get :no_of_doors_list
        get :no_of_cylinder_list
        get :steering_side_list
        get :features_list
        get :extras_list
        get :badges_list
        get :ads_posted_list
        get :other_filters_list
        get :warranty_list
        get :free_ad_count
        get :seller_type_list
        get :subscription_plan_summary
        post :make
        post :models
        post :trims
        get :price_data
        get :search_home
      end
    end
    post :create_vehicle_inspection, controller: "vehicle_inspections"

    resources :vehicle_inspections do
      collection do
        get :inspection_payment_details
        get :my_inspections
        get :get_inspection_amount
        post :payment
        get :payment_status
        get :inspection_report
        post :update_acceptance_status
        post :update_instant_deposit_status
        get :show_notification
        put :read_notification
        get :unread_notification
        get :unread_notification_count
        put :store_device_id
        get :show_inspection
      end
    end
  end

  namespace :bx_block_mixpanel_integration do 
    resource :mixpanel_integrations do 
      collection do
        get :total_profile
        get :total_project
        get :total_account
        get :total_award
        get :total_post
        get :total_car_ads
        get :total_car_order
        get :country_base_accounts
      end
    end 
  end 

  namespace :bx_block_rate_card do 
    resource :inspection_charges, only: [:create, :index] do 
      collection do
        get :get_inspection_charges
        get :get_all_country
        get :get_all_region
      end
    end
    resource :shipping_charges, :except => [:show] do 
      collection do
        get :get_shipping_charges
        get :get_all_source_country
        get :get_all_destination_country
      end
    end
    resource :documentation_charges do 
      collection do
        get :get_documentation_charges
        get :get_all_country
      end
    end
    resource :destination_handlings, only: [:create] do 
      collection do
        get :get_all_handling_charges
        get :get_all_source_country
        get :get_all_destination_country
      end
    end
  end

  namespace :bx_block_ordercreation3 do 
    resource :car_orders, only: [:create] do
      collection do 
        get :get_all_buy_request
        put :upload_document
        get :get_documents
        get :order_cancelled
        get :get_order
        post :payment
        get :payment_status
        post :request_inspection
        get :buy_car
      end
    end
    get :order_status, controller: "order_statuses"
    get :shipment_status, controller: "order_statuses"
  end

  namespace :bx_block_invoicebilling do 
    get :get_bank_details, controller: "bank_details"
  end

  namespace :bx_block_payments do 
    resources :payment_intents, only: [:new, :create]
    resources :stripe_webhook do
      collection do
        post :callback
        post :payment_link_response
      end
    end
  end

  namespace :bx_block_plan do 
    resource :plan do 
      get :index
      post :create_user_subsciption
    end
  end
  namespace :bx_block_location do
    resources :locations do
      collection do
        get :region_list
        get :country_list
        get :state_list
        get :area_list
      end
    end
  end

  namespace :bx_block_shipment  do 
    get :get_shipping_detail, controller: "shipments"
    put :upload_documents, controller: "shipments"
    post :review, controller: "shipments"
  end

  namespace :bx_block_advertisement do 
    get :advertisement_lists ,controller: "advertisements"
  end

  namespace :bx_block_services do
    resources :services, only: [:index]
  end

  namespace :bx_block_push_notifications do
    resource :push_notifications, only: [:create, :show] do 
      collection do 
        get :get_notifications_list
        put :update_notification
      end
    end
  end

  namespace :bx_block_vehicle_shipping do 
    resources :vehicle_shippings, only: [:create, :update, :show] do 
      collection do 
        get :get_user_shipment_list
        put :upload_customer_receipt
        get :get_proof_of_delivery
        get :order_details
        get :shipping_cancelled
        get :complete_tracking_order
      end
    end

    resources :vehicle_sellings do 
      post :varify, on: :collection
      get :vehicle_without_token, on: :collection
    end
    resources :vehicle_orders do 
      post :create, on: :collection
      get :get_order, on: :collection
      post :request_inspection, on: :collection
      collection do 
        get :get_order_details
        get :get_purchased
        get :order_cancelled
        get :get_documents
        put :upload_document
      end
    end
  end

  namespace :bx_block_whatsapp_number do
    resources :whatsapp_numbers, only: :index
  end

  namespace :bx_block_categories do
    resources :categories, only: :index
  end
  
  
  namespace :bx_block_subscription do 
    get :show, controller: "subscriptions"
    post :save, controller: "subscriptions"
  end

  get "/bx_block_vehicle_selling/selling" => "bx_block_vehicle_shipping/vehicle_sellings#vehicle_selling"
  post "/bx_block_vehicle_payment/payment" => "bx_block_vehicle_shipping/vehicle_payments#payment"
  post "/bx_block_review/review" => "bx_block_reviews/app_reviews#create"
  get "/shipment/countries" => "bx_block_vehicle_shipping/vehicle_shippings#all_country"
  get "/shipment/ports" => "bx_block_vehicle_shipping/vehicle_shippings#port"
  post "/shipment/payment" => "bx_block_vehicle_shipping/shipping_payments#payment"
  get "/bx_block_vehicle_shipping/vehicle_shippings/get_final_invoice/:id" => "bx_block_vehicle_shipping/vehicle_shippings#get_final_invoice"
  put "/bx_block_vehicle_shipping/vehicle_shippings/admin_notes/:id" => "bx_block_vehicle_shipping/vehicle_shippings#admin_notes"
  put "/shipment/place/order/:shipment_id" => "bx_block_vehicle_shipping/vehicle_shippings#place_order"
  post "/shipment/receipt" => "bx_block_vehicle_shipping/vehicle_shippings#upload_receipt"
  
  get "/bx_block_rate_card/shipping_charges/check_price_availability" => "bx_block_rate_card/shipping_charges#check_price_availability"

  resources :service_shipping, only: [:index]
end