module BxBlockFilterItems
  class CarAdsFilter < ApplicationFilter

    private

    def query_string_for(attr_name, value)
      attr_name = attr_name.to_sym
      case attr_name
      when :city_id
        ids = [*value].join(',')
        "car_ads.city_id IN (#{ids})"
      when :from_price
        "car_ads.price >= #{value}"
      when :to_price
        "car_ads.price <= #{value}"
      when :make_id
        ids = [*value].join(',')
        "models.company_id IN (#{ids})"
      when :model_id
        ids = [*value].join(',')
        "models.id IN (#{ids})"
      when :trim_id
        ids = [*value].join(',')
        "trims.id IN (#{ids})"
      when :from_year
        "car_ads.make_year >= '#{value}'"
      when :to_year
        "car_ads.make_year <= '#{value}'"
      # when :from_kms
      #   "car_ads.kms >= '#{value}'"
      # when :to_kms
      #   "car_ads.kms <= '#{value}'"
      when :regional_spec_ids
        ids = [*value].join(',')
        "regional_specs.id IN (#{ids})"
      when :seller_type_ids
        ids = [*value].join(',')
        "seller_types.id IN (#{ids})"
      when :body_type
        body_types = [*value].join(',')
        "car_ads.body_type IN ('#{body_types}')"
      # when :car_engine_type_ids
      #   ids = value.split(',')
      #   if ids.length == 2
      #     "car_engine_types.id IN(#{ids[0]}) AND car_engine_types.id IN(#{ids[1]})"  
      #   else
      #     "car_engine_types.id IN (#{ids.join(',')})"  
      #   end
        
      when :color_ids
        ids = [*value].join(',')
        "colors.id IN (#{ids})"
      when :horse_power_to
        "car_ads.horse_power <= '#{value}'"
      when :horse_power_from
        "car_ads.horse_power >= '#{value}'"
      when :no_of_doors
        ids = [*value].join(',')
        "car_ads.no_of_doors IN (#{ids})"
      when :warranty
        data = [*value].join(',')
        "car_ads.warranty IN (#{data})"
      when :no_of_cylinder
        "car_ads.no_of_cylinder = #{value}"
      when :steering_side
        data = [*value].join(',')
        "car_ads.steering_side IN (#{data})"
      when :car_type
        data = [*value].join(',')
        "car_ads.car_type IN (#{data})"
      when :badge_ids
        ids = [*value].join(',')
        "badges.id IN (#{ids})"
      when :feature_ids
        ids = [*value].join(',')
        "features.id IN (#{ids})"
      when :extra_ids
        ids = [*value].join(',')
        "extras.id IN (#{ids})"
      when :ads_posted
        ads_posted_filter(value) 
      when :dealer_ids
        ids = [*value].join(',')
        "car_ads.account_id IN (#{ids})"
      else
        ""
      end
    end

    def ads_posted_filter(value)
      current_date = Time.current.to_date

      case value
      when 'Any Time'
        "DATE(car_ads.created_at) >= '#{current_date - 30.days}'"
      when 'Today'
        "DATE(car_ads.created_at) = '#{current_date.to_date}'"
      when 'Within 3 days'
        "DATE(car_ads.created_at) >= '#{current_date - 3.days}'"
      when 'Within 1 week'
        "DATE(car_ads.created_at) >= '#{current_date - 7.days}'"
      when 'Within 2 weeks'
        "DATE(car_ads.created_at) >= '#{current_date - 14.days}'"
      when 'Within 1 month'
        "DATE(car_ads.created_at) >= '#{current_date - 1.month}'"
      when 'Within 3 month'
        "DATE(car_ads.created_at) >= '#{current_date - 3.month}'"
      when 'Within 6 month'
        "DATE(car_ads.created_at) >= '#{current_date - 6.month}'"
      end
    end
  end
end
