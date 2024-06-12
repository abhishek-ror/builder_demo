module BxBlockPosts
  class CarAdsController < ApplicationController
    before_action :load_car_ad, only: [:show, :update, :destroy, :verify_otp_to_post, :resend_otp]
    before_action :set_current_user, only: [ :create, :update, :destroy, :my_ads]
    skip_before_action :validate_json_web_token, only: [:index, :show, :search, :query_data, :search_cars_by_brand, :car_search, :all_cars]
    before_action :page_from_params, only: [:search, :search_cars_by_brand]

    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    def create
      if params[:car_ad].blank? 
        raise 'Wrong input data'
      end
      ActiveRecord::Base.transaction do
        @car_ads = BxBlockAdmin::CarAd.new(car_ad_params.merge(account_id: current_user.id, user_subscription_id: current_user.latest_subscription_plan.id))
        if @car_ads.valid? && @car_ads.save
          @car_ads.send_email_otp(request.base_url)
        else
          return render json: {success: false, message: @car_ads.errors.full_messages.join}, status: :unprocessable_entity
        end
      end

      render json: BxBlockPosts::CarAdSerializer.new(@car_ads, serialization_options)
                       .serializable_hash.deep_transform_values{|attribute| attribute.to_s},
             status: :created
    end

    def show
      return if @car_ad.nil?

      render json: BxBlockPosts::CarAdSerializer.new(@car_ad, serialization_options)
                       .serializable_hash,
             status: :ok
    end

    def index  
      vehicle_ads = []
      if params[:car_type].present? && params[:ad_type].present?
        car_ads = BxBlockAdmin::CarAd.where(car_type: params[:car_type], ad_type: params[:ad_type]).posted.order('created_at DESC')
        if params[:car_type] == 'used_car'
          vehicle_ads =  BxBlockVehicleShipping::VehicleSelling.Posted.order('created_at DESC')
        end
      elsif params[:ad_type].present?
        car_ads = BxBlockAdmin::CarAd.where(ad_type: params[:ad_type]).posted.order('created_at DESC')
        vehicle_ads =  BxBlockVehicleShipping::VehicleSelling.Posted.order('created_at DESC')
      else
        car_ads = BxBlockAdmin::CarAd.all.posted.order('created_at DESC')
        vehicle_ads =  BxBlockVehicleShipping::VehicleSelling.Posted.order('created_at DESC')
      end

      serializer_vehicle_ads = BxBlockVehicleShippings::VehicleSellingSerializer.new(vehicle_ads, params: { current_user_id: @current_user&.id })
      serializer_car_ads = BxBlockPosts::CarAdSerializer.new(car_ads, params: { current_user_id: @current_user&.id })

      combined_data = serializer_vehicle_ads.serializable_hash[:data] + serializer_car_ads.serializable_hash[:data]

      sorted_data = combined_data.sort_by { |x| x["created_at"] }

      render json: { 'data': sorted_data }, status: :ok
    end

    def my_ads
      car_ads = current_user.car_ads.where(status: params[:status])
      serializer = BxBlockPosts::CarAdSerializer.new(car_ads, serialization_options)
      render json: serializer, status: :ok
    end

    def status_update
      if params[:id].present? && params[:status].present?
        car_ad = current_user.car_ads.find_by(id: params[:id])
        if car_ad.nil?
          render json: {
              message: "CarAd with id #{params[:id]} doesn't exists"
          }, status: :ok
        else
          if car_ad.update(status: params[:status])
            render json: BxBlockPosts::CarAdSerializer.new(car_ad, serialization_options), status: :ok
          else
            render json: {success: false, message: car_ad.errors.full_messages.join}, status: :unprocessable_entity
          end
        end
      else
        render json: { error: { message: "id and status field Can't Be Blank" } }, status: :ok
      end
    end

    def destroy
      return if @car_ad.nil?

      begin
        if @car_ad.destroy

          render json: { success: true }, status: :ok
        end
      rescue ActiveRecord::InvalidForeignKey
        message = "Record can't be deleted due to reference to a catalogue " \
                  "record"

        render json: {
          error: { message: message }
        }, status: :internal_server_error
      end
    end

    def update
      return if @car_ad.nil?

      update_result = @car_ad.update(car_ad_params.merge(user_subscription_id: @current_user.latest_subscription_plan.id))

      if update_result
        render json: BxBlockPosts::CarAdSerializer.new(@car_ad).serializable_hash.deep_transform_values{|attribute| attribute.to_s},
               status: :ok
      else
        render json: ErrorSerializer.new(@car_ad).serializable_hash,
               status: :unprocessable_entity
      end
    end

    def query_data
      render json: BxBlockAdmin::CarAd.query_data
    end

    def search
      car_ads = car_ads_joins(car_ads)
      car_ads = BxBlockFilterItems::CarAdsFilter.new(car_ads, params.except(:other_filters, :no_of_cylinder, :horse_power_to, :horse_power_from, :horse_power, :no_of_doors, :body_type)).call

      from_kms = params[:from_kms].presence
      to_kms = params[:to_kms].presence

      if from_kms.present? || to_kms.present?
        if from_kms.present? && to_kms.present?
          car_ads = BxBlockAdmin::CarAd.where("CAST(kms AS INTEGER) BETWEEN :from_kms_value AND :to_kms_value", from_kms_value: from_kms.to_i, to_kms_value: to_kms.to_i).posted
        elsif from_kms.present?
          car_ads = BxBlockAdmin::CarAd.where("CAST(kms AS INTEGER) >= :from_kms_value", from_kms_value: from_kms.to_i).posted
        else
          car_ads = BxBlockAdmin::CarAd.where("CAST(kms AS INTEGER) <= :to_kms_value", to_kms_value: to_kms.to_i).posted
        end
      end

      if params[:no_of_cylinder].present?
        car_ads = cylinder_filter(car_ads ,params)
      end
      
      if params[:no_of_doors].present?
        car_ads = door_filter(car_ads, params)
      end

      if params[:horse_power].present?
        car_ads  =  horse_power_filter(car_ads, params)
      end

      if params[:body_type].present?
        body_type = params[:body_type].split(",").map(&:strip)
        car_ads = car_ads.where(body_type: body_type)
      end

      if params[:car_engine_type_ids].present?
        car_engine_type_ids = params[:car_engine_type_ids].split(',').map(&:strip)
        if car_engine_type_ids.present? && car_engine_type_ids.length == 2
          car_ads = car_ads.joins('INNER JOIN car_ads_engine_types as c1 ON c1.car_ad_id = car_ads.id INNER JOIN car_engine_types as e1 ON e1.id = c1.car_engine_type_id')
          .joins('INNER JOIN car_ads_engine_types as c2 ON c2.car_ad_id = car_ads.id INNER JOIN car_engine_types as e2 ON e2.id = c2.car_engine_type_id')
          .where("e1.id = #{car_engine_type_ids[0]}").where("e2.id = #{car_engine_type_ids[1]}")
        else
          car_ads = car_ads.joins(:car_engine_types)
          car_ads = car_ads.where(car_engine_types: {id: car_engine_type_ids})
        end
      end
      car_ads = car_ads.distinct.order(created_at: :desc).page(params[:page]).per(params[:limit])
      
      render json: BxBlockPosts::CarAdSerializer.new(car_ads).serializable_hash.deep_transform_values{|attribute| attribute.to_s}.merge(pagination(car_ads)),
               status: :ok
      
    end

    def search_home
      car_ads = car_ads_joins(car_ads)
      car_ads = BxBlockFilterItems::CarAdsFilter.new(car_ads, params.except(:other_filters, :no_of_cylinder, :horse_power_to, :horse_power_from, :horse_power, :no_of_doors, :body_type, :price, :make_year, :kms, :warranty, :steering_side)).call
      
      if params[:no_of_cylinder].present?
        car_ads = cylinder_filter(car_ads ,params)
      end

      if params[:no_of_doors].present?
        car_ads = door_filter(car_ads, params)
      end

      if params[:horse_power].present?
        car_ads  =  horse_power_filter(car_ads, params)
      end

      car_ads = home_car_filter(params,car_ads)

      if params[:car_engine_type_ids].present?
        car_engine_type_ids = params[:car_engine_type_ids].split(',').map(&:strip)
        if car_engine_type_ids.present? && car_engine_type_ids.length == 2
          car_ads = car_ads.joins('INNER JOIN car_ads_engine_types as c1 ON c1.car_ad_id = car_ads.id INNER JOIN car_engine_types as e1 ON e1.id = c1.car_engine_type_id')
          .joins('INNER JOIN car_ads_engine_types as c2 ON c2.car_ad_id = car_ads.id INNER JOIN car_engine_types as e2 ON e2.id = c2.car_engine_type_id')
          .where("e1.id = #{car_engine_type_ids[0]}").where("e2.id = #{car_engine_type_ids[1]}")
        else
          car_ads = car_ads.joins(:car_engine_types)
          car_ads = car_ads.where(car_engine_types: {id: car_engine_type_ids})
        end
      end
      car_ads = car_ads.distinct.order(created_at: :desc).page(params[:page]).per(params[:limit])
      render json: BxBlockPosts::CarAdSerializer.new(car_ads).serializable_hash.deep_transform_values{|attribute| attribute.to_s}.merge(pagination(car_ads)),
               status: :ok
      
    end

    def verify_otp_to_post
      if params[:otp] == @car_ad.otp
        @car_ad.update(status: "posted")
        render json: { success: true }, status: :ok
      else
        render json: { success: false }, status: :ok
      end
    end

    def resend_otp
      @car_ad.send_email_otp(request.base_url)
      render json: { message: "OTP resent" }
    end

    def location_list
      cities = BxBlockAdmin::CarAd.select('cities.id as city_id', 'cities.name').joins(:city).distinct('cities.id').as_json(only: [:city_id, :name])
      render json: {cities: cities, success: true}, status: :ok
    end

    def make_list
      company_ids = []
      if params[:city_id].present?
        # car_ads = BxBlockAdmin::CarAd.where(city_id: params[:city_id])
        company_ids = BxBlockAdmin::CarAd.where(city_id: params[:city_id]).joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").select("models.company_id as company_id").pluck(:company_id).uniq
        # @makers = BxBlockAdmin::Company.select(:id, :name).where(id: company_ids.uniq).order(name: :asc).uniq
      else
        company_ids = BxBlockAdmin::CarAd.joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").select("models.company_id as company_id").pluck(:company_id).uniq
        # @makers = BxBlockAdmin::Company.select(:id, :name).where(id: company_ids.uniq).order(name: :asc).uniq
      end
      
      makers = BxBlockAdmin::Company.select(:id, :name).where(id: company_ids.uniq).order(name: :asc).uniq
      render json: {makers: makers, success: true}, status: :ok
    end

    def model_list
      model_ids = []
      if params[:city_id].present? && params[:make_id].present?
        make_ids = [*params[:make_id]].join(',')

        model_ids = BxBlockAdmin::CarAd.where(city_id: params[:city_id]).joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").where("models.company_id IN (#{make_ids})").select("models.id as model_id")
        
      elsif params[:make_id].present?
        make_ids = [*params[:make_id]].join(',')
        model_ids = BxBlockAdmin::CarAd.joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").where("models.company_id IN (#{make_ids})").select("models.id as model_id")
        
      elsif params[:city_id].present?
        model_ids = BxBlockAdmin::CarAd.where(city_id: params[:city_id]).joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").select("models.id as model_id")

      else
        model_ids = BxBlockAdmin::CarAd.joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").select("models.id as model_id")
      end

      models = BxBlockAdmin::Model.where(id: model_ids.pluck(:model_id).uniq).select(:name, :id).as_json
      render json: {models: models, success: true}, status: :ok
    end

    def car_search
      car_name = params[:car_name]
      car_ads = BxBlockAdmin::CarAd.joins(:trim).where("lower(trims.name) LIKE ? ", "%#{car_name}%")
      vehicle_ads =  BxBlockVehicleShipping::VehicleSelling.joins(:trim).where("lower(trims.name) LIKE ? ", "%#{car_name}%").order('created_at DESC')
      serializer = BxBlockPosts::CarAdSerializer.new(car_ads, {params: {current_user_id: @current_user&.id}}).serializable_hash[:data] << BxBlockVehicleShippings::VehicleSellingSerializer.new(vehicle_ads, params: {current_user_id: @current_user&.id}).serializable_hash[:data]
      render json: {'data': serializer.flatten.sort_by{|x| x["created_at"]}}, status: :ok
    end

    def all_cars
      page = params[:page].to_i.positive? ? params[:page].to_i : 1
      per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10

      if params[:search].present?
        search_query = params[:search].strip.downcase

        car_ads = BxBlockAdmin::CarAd.joins(trim: { model: :company }).posted
                                .where("lower(models.name) LIKE :query OR lower(companies.name) LIKE :query", query: "%#{search_query}%")
        vehicle_ads =  BxBlockVehicleShipping::VehicleSelling.joins(trim: { model: :company }).Posted.where("lower(models.name) LIKE :query OR lower(companies.name) LIKE :query", query: "%#{search_query}%").order('created_at DESC')
        
        total_cars = car_ads.count + vehicle_ads.count
        if car_ads.count < per_page/2
          total_pages = (total_cars.to_f / per_page).ceil
          per_page_new = per_page - car_ads.count
          car_ads = car_ads.page(page).per(per_page/2)
          vehicle_ads = vehicle_ads.page(page).per(per_page_new)
        elsif vehicle_ads.count < per_page/2
          total_pages = (total_cars.to_f / per_page).ceil
          per_page_new = per_page - vehicle_ads.count
          vehicle_ads = vehicle_ads.page(page).per(per_page/2)
          car_ads = car_ads.page(page).per(per_page_new)
        else
          total_pages = (total_cars.to_f / per_page).ceil
          car_ads = car_ads.page(page).per(per_page/2)
          vehicle_ads = vehicle_ads.page(page).per(per_page/2)
        end
        if total_cars == 0
          render json: { error: "No cars found for the search '#{params[:search]}'" }, status: :not_found
        else
          serializer =  BxBlockVehicleShippings::VehicleSellingSerializer.new(vehicle_ads, params: {current_user_id: @current_user&.id}).serializable_hash[:data] << BxBlockPosts::CarAdSerializer.new(car_ads, {params: {current_user_id: @current_user&.id}}).serializable_hash[:data]
          render json: { total_pages: total_pages, AllSearchedCars: {'data': serializer.flatten.sort_by{|x| x["created_at"]}}, }, status: :ok
        end
      else
        render json: { error: "Search parameter is required" }, status: :unprocessable_entity
      end
    end

    def trim_list
      trim_ids = []
      
      if params[:city_id].present? && params[:make_id].present? && params[:model_id].present?
        model_ids = [*params[:model_id]].join(',')
        make_ids = [*params[:make_id]].join(',')

        trim_ids = BxBlockAdmin::CarAd.where(city_id: params[:city_id]).joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").where("models.company_id IN(#{make_ids}) and models.id IN(#{model_ids})").select(:trim_id)
      elsif params[:make_id].present? && params[:model_id].present?
        model_ids = [*params[:model_id]].join(',')
        make_ids = [*params[:make_id]].join(',')

        trim_ids = BxBlockAdmin::CarAd.joins(:trim).joins("INNER JOIN models on models.id = trims.model_id").where("models.company_id IN(#{make_ids}) and models.id IN(#{model_ids})").select(:trim_id)
      elsif params[:city_id].present?
        trim_ids = BxBlockAdmin::CarAd.where(city_id: params[:city_id]).select(:trim_id)
      else
        trim_ids = BxBlockAdmin::CarAd.select(:trim_id).distinct(:trim_id)
      end
      
      trims = BxBlockAdmin::Trim.where(id: trim_ids.pluck(:trim_id).uniq).select(:id, :name)
      render json: {trims: trims, success: true}, status: :ok
    end

    def year_list
      render json: {data: BxBlockAdmin::CarAd::MODEL_YEAR, success: true}, status: :ok
    end

    def regional_spec_list
      render json: {data: BxBlockAdmin::RegionalSpec.select(:id, :name).as_json, success: true}, status: :ok
    end

    def body_type_list
      render json: {data: (BxBlockAdmin::Model.pluck(:body_type).uniq + BxBlockAdmin::CarAd.pluck(:body_type)).flatten.compact.uniq, success: true}, status: :ok
    end

    def engine_type_list
      render json: {data: BxBlockAdmin::CarEngineType.select(:id, :name, :engine_type).as_json, success: true}, status: :ok
    end

    def body_color_list
      render json: {data: BxBlockAdmin::Color.select(:id, :name).as_json, success: true}, status: :ok
    end

    def horse_power_list
      render json: {data: BxBlockAdmin::CarAd::HORSE_POWER.map{|a| a.slice(:id, :name)}, success: true}, status: :ok
    end

    def no_of_doors_list
      render json: {data: BxBlockAdmin::CarAd::DOORS, success: true}, status: :ok
    end

    def no_of_cylinder_list
      render json: {data: BxBlockAdmin::CarAd::CYLINDERS, success: true}, status: :ok
    end

    def price_data
      # render json: {data: BxBlockAdmin::CarAd::PRICE, success: true}, status: :ok
      render json: {data: BxBlockAdmin::CarAd.pluck(:price)&.compact&.uniq&.sort(), success: true}, status: :ok
    end

    def steering_side_list
      render json: {data: BxBlockAdmin::CarAd::STEERING_SIDES_VALUES.map.each_with_index{|a, index| {id: index + 1, name: a}}, success: true}, status: :ok
    end

    def features_list
      render json: {data: BxBlockAdmin::Feature.select(:id, :name).as_json, success: true}, status: :ok
    end

    def extras_list
      render json: {data: BxBlockAdmin::Extra.select(:id, :name).as_json, success: true}, status: :ok
    end

    def badges_list
      render json: {data: BxBlockAdmin::Badge.select(:id, :name).as_json, success: true}, status: :ok
    end

    def ads_posted_list
      render json: {data: BxBlockAdmin::CarAd::ADS_POSTED, success: true}, status: :ok
    end

    def other_filters_list
      render json: {data: BxBlockAdmin::CarAd::OTHER_FILTERS.map.each_with_index{|a, index| {id: index + 1, name: a}}, success: true}, status: :ok
    end

    def warranty_list
      render json: {data: BxBlockAdmin::CarAd::WARRANTY.map.each_with_index{|a, index| {id: index + 1, name: a}}, success: true}, status: :ok
    end

    def free_ad_count
      free_ad_posted = current_user.car_ads.posted.count
      render json: { ad_available_total: (3 - free_ad_posted), ads_posted: free_ad_posted, total_count: 3}
    end

    def seller_type_list
      render json: {success: true, data: BxBlockAdmin::SellerType.select(:id, :name).as_json, car_type: BxBlockAdmin::CarAd::CAR_TYPE.map.each_with_index{|a, index| {id: index + 1, name: a}} }, status: :ok
    end

    def subscription_plan_summary
      posted_ad_count = current_user.latest_subscription_plan.car_ads.where.not(status: "drafted").count rescue 0
      total_ad_count = current_user.latest_subscription_plan.plan.ad_count rescue 0
      res = { 
        user_subscription_plan: current_user.latest_subscription_plan,
        requested_subscription_plan: current_user.requested_subscription_plan,
        ads_posted: posted_ad_count,
        ads_available: total_ad_count - posted_ad_count,
        total_plan_ads: total_ad_count,
        plan: current_user.latest_subscription_plan&.plan,
        requested_subscription_plan_details: current_user.requested_subscription_plan&.plan
      }
      render json: { data: res, status: :success}
    end

    def models
      company = BxBlockAdmin::Company.find_by(id: params[:model][:company_id])
      model = BxBlockAdmin::Model.create(name: params[:model][:name], company_id: company.id)
      if company
        render json: BxBlockContentManagement::ModelSerializer.new(model),
        status: :ok
      else
        render json: ErrorSerializer.new(model).serializable_hash,
        status: :unprocessable_entity
      end
    end

    def trims
      model = BxBlockAdmin::Model.find_by(id: params[:trim][:model_id])
      trim =  BxBlockAdmin::Trim.create(name: params[:trim][:name], model_id: model.id)
      if trim
        render json: BxBlockContentManagement::TrimSerializer.new(trim),
        status: :ok
      else
        render json: ErrorSerializer.new(trim).serializable_hash,
        status: :unprocessable_entity
      end
    end

    def make
      company = BxBlockAdmin::Company.create(name: params[:company][:name])
      if company
        render json: BxBlockContentManagement::CompanySerializer.new(company),
        status: :ok
      else
        render json: ErrorSerializer.new(company).serializable_hash,
        status: :unprocessable_entity
      end
    end

    def search_cars_by_brand
      if params[:brand_id].present?
        car_ads = BxBlockAdmin::CarAd.where(status: 'posted').joins(trim: :model).where('models.company_id = ?', params[:brand_id])
        vehicle_ads = BxBlockVehicleShipping::VehicleSelling.where(tracking_status: 'Posted').joins(trim: :model).where('models.company_id = ?', params[:brand_id]).order('created_at DESC').page(params[:page]).per(params[:limit]/2)
        car_ads = car_ads.order(created_at: :desc).page(params[:page]).per(params[:limit]/2)
        current_user = AccountBlock::Account.find_by(id: params[:account_id]) if params[:account_id]
        serializer = BxBlockVehicleShippings::VehicleSellingSerializer.new(vehicle_ads, params: {current_user_id: @current_user&.id}).serializable_hash[:data] << BxBlockPosts::CarAdSerializer.new(car_ads, {params: {current_user_id: current_user&.id}}).serializable_hash[:data]
        render json: {data: serializer.flatten}.merge(total_pagination(car_ads, vehicle_ads)),
               status: :ok
      else
        render json: {status: 422, message: 'Brand Id is missing'}, status: 422
      end
    end

    private

    def car_ads_joins(car_ads)
      car_ads = BxBlockAdmin::CarAd.joins("INNER JOIN trims ON trims.id = car_ads.trim_id INNER JOIN models ON models.id = trims.model_id").posted
      car_ads = car_ads.joins(:regional_specs) if params[:regional_spec_ids].present?
      car_ads = car_ads.joins(:seller_types) if params[:seller_type_ids].present?
      # car_ads = car_ads.joins(:car_engine_types) if params[:car_engine_type_ids].present?
      car_ads = car_ads.joins(:colors) if params[:color_ids].present?
      car_ads = car_ads.joins(:badges) if params[:badge_ids].present?
      car_ads = car_ads.joins(:features) if params[:feature_ids].present?
      car_ads = car_ads.joins(:extras) if params[:extra_ids].present?
      car_ads = car_ads.joins(:images).where.not(images: {id: nil}) if params[:other_filters].present? && params[:other_filters].split(",").map(&:to_i).include?(1)
      return car_ads
    end

    def car_ad_params
      params.require(:car_ad).permit(:trim_id, :city_id, :body_type,:make_year, :mileage, :more_details, :regional_spec,:no_of_doors, :no_of_cylinder, :horse_power, :warranty, :battery_capacity, :car_type , :steering_side, :body_color, :transmission, :price, :mobile_number, :kms, :fuel_type_description, extra_ids: [],feature_ids: [], images_attributes: [:id, :image], badge_ids: [], regional_spec_ids: [], color_ids: [], seller_type_ids: [], car_engine_type_ids: [])
    end


    def home_car_filter(params, car_ads)
      car_ads =  car_ads
      if params[:body_type].present?
        body_type = params[:body_type].split(",").map(&:strip)
        car_ads = car_ads.where(body_type: body_type)
      end

      if params[:make_year].present?
        make_year = params[:make_year].split(",").map(&:strip)
        car_ads = car_ads.where(make_year: make_year)
      end

      if params[:kms].present?
        kms = params[:kms].split(",").map(&:strip)
        car_ads = car_ads.where(kms: kms)
      end

      if params[:warranty].present?
        warranty = params[:warranty].split(",").map(&:strip)
        car_ads = car_ads.where(warranty: warranty)
      end

      if params[:steering_side].present?
        steering_side = params[:steering_side].split(",").map(&:strip)
        car_ads = car_ads.where(steering_side: steering_side)
      end
      return car_ads  
    end

    def load_car_ad
      @car_ad = BxBlockAdmin::CarAd.find_by(id: params[:id])

      if @car_ad.nil?
        render json: {
            message: "CarAd with id #{params[:id]} doesn't exists"
        }, status: :not_found
      end
    end

    def cylinder_filter(car_ads, params)
      car_ads = car_ads
      no_of_cylinder = []
      cylinders = params[:no_of_cylinder].split(",").map(&:to_i)
      cylinders.each{|cl| 
        if cl == 13
          no_of_cylinder += [nil, '']
        else
          no_of_cylinder << cl
        end
      }
      
      if no_of_cylinder.present?
        car_ads = car_ads.where(no_of_cylinder: no_of_cylinder)
      end
      return car_ads
    end

    def door_filter(car_ads, params)
      car_ads = car_ads
      no_of_doors = params[:no_of_doors].split(",").map(&:to_i)
      doors = []
      no_of_doors.each{|door| 
        if door == 5
          doors += [5..100]
        elsif door == 6
          doors << nil
        else
          doors << door
        end
      }
      if doors.present?
        car_ads = car_ads.where(no_of_doors: doors)
      end
      return car_ads
    end

    def horse_power_filter(car_ads, params)
      # car_ads = car_ads
      # horse_power = params[:horse_power].split(",").map(&:to_i)
      # horse_powers = BxBlockAdmin::CarAd::HORSE_POWER.select{|hp| horse_power.include?(hp[:id])}
      # horse_power_from = horse_powers.pluck(:start).min
      # horse_power_to = horse_powers.pluck(:end).max
      # if horse_power_to.present? && horse_power_from.present?
      #   car_ads = car_ads.where(horse_power: (horse_power_from..horse_power_to))
      # end
      # return car_ads

      horse_power = params[:horse_power].to_i

      if horse_power.positive?
        car_ads = car_ads.where('horse_power <= ?', horse_power)
      end

      car_ads
    end

    def serialization_options
      options = {}
      options[:params] = {}
      options
    end

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end

    def set_current_user
      return unless @token
      @current_user ||= AccountBlock::Account.find(@token.id)
    end
  end
end