module BxBlockAdmin
  class ContentsController < BxBlockAdmin::ApplicationController

    def terms_and_conditions
      content = BxBlockAdmin::TermsAndCondition.all
      render json: BxBlockContentManagement::TermsAndConditionSerializer.new(content, meta: {
                     message: "All Terms and Conditions"
                   }).serializable_hash, status: :ok
    end

    def global_offices
      content = BxBlockAdmin::GlobalOffice.all
      render json: BxBlockContentManagement::GlobalOfficeSerializer.new(content, meta: {
                message: "All Global Offices"
              }).serializable_hash, status: :ok
    end

    def contact_us
      content = BxBlockAdmin::ContactUs.new(contact_us_params)
      if content.save
        render json: BxBlockContentManagement::ContactUsSerializer.new(content, meta: {
                  message: "Contact Us Query"
                }).serializable_hash, status: :ok
      else
        render json: {errors: content.errors},
               status: :unprocessable_entity
      end

    end

    def banner_images
     content = BxBlockAdmin::Banner.all
     render json: BxBlockContentManagement::BannerSerializer.new(content, meta: {
                     message: "Banners"
                   }).serializable_hash, status: :ok
    end
    
    def get_regional_specs
      render json: {data: BxBlockAdmin::RegionalSpec.select(:id, :name).order(name: :asc).as_json, success: true}, status: :ok
    end

    def flash_screens
     content = BxBlockAdmin::FlashScreen.all
     content = content.where(screen_type: params[:screen_type]) if params[:screen_type].present?
     render json: BxBlockContentManagement::FlashScreenSerializer.new(content, meta: {
                     message: "Flash Screens"
                   }).serializable_hash, status: :ok
    end


    def companies
      companies = BxBlockAdmin::Company.all
      
        if companies.present?
            render json: {companies: BxBlockContentManagement::CompanySerializer.new(companies)}
        else
            render json: {Message: "No companies available"}
        end
    end

    def models
      render json: BxBlockAdmin::Model.where("company_id = ?",params[:company_id]) , status: :ok
    end

    def make_year_list
      render json: { make_years: BxBlockAdmin::CarAd.all.map{|car_ad| car_ad.as_json.slice("id", "make_year")}.uniq }, status: :ok
    end

    def car_price_list
      car_prices = []
      if params[:model_id].present?
        trims = BxBlockAdmin::Trim.where("model_id = ?",params[:model_id])
        trims.find_each do |trim|
          car_prices << trim.car_ads.map {|car_ad| {'id'=> car_ad['id'], 'price'=> car_ad['price'].to_s }}
        end
        render json: { car_price_list:  car_prices.flatten }, status: :ok
      else
        render json: { car_price_list: car_prices }, status: :ok
      end
    end

    def companies_by_make_year
      companies = []
      if params[:make_year].present?
        trims = BxBlockAdmin::Trim.joins(:car_ads).where("car_ads.make_year= ?", params[:make_year])
        trims.each do |trim|
          companies.push(trim.model.company)
        end
        render json: { companies_list: companies }, status: :ok
      else
        render json: { companies_list: companies }, status: :ok
      end
    end

    def all_companies_list
      companies_with_models = BxBlockAdmin::Company.includes(:models)
      
      return render json: { message: "No companies available" } unless companies_with_models.present?
      
      companies_list = companies_with_models.map do |c|
        {
          id: c.id,
          name: c.name,
          models: c.models.map { |m| { id: m.id, name: m.name } }
        }
      end
      
      render json: { companies_list: companies_list }, status: :ok
    end

    def trims
      model = BxBlockAdmin::Model.where(id: params[:model_id]).last
      trims = model.trims
      render json: trims
    end

    def regions
      regions = BxBlockAdmin::Region.all
      render json: regions
    end

    def countries
      region = BxBlockAdmin::Region.where(id: params[:region_id]).last
      countries = region.countries
      render json: countries
    end

    def states
      country = BxBlockAdmin::Country.where(id: params[:country_id]).last
      states = country.states
      render json: states
    end

    def cities
      state = BxBlockAdmin::State.where(id: params[:state_id]).last
      cities = state.cities
      render json: cities
    end

    def subscription_plans
      subscription_plans = BxBlockPlan::Plan.where.not(name: "Free Plan")
      render json: subscription_plans
    end

    private

    def contact_us_params
      params.require(:contact_us).permit(:description, :name, :email)
    end
  end
end
