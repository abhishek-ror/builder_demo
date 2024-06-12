module AccountBlock
  module Accounts
    class CountryCodeAndFlagsController < ApplicationController
      def show
        render json: CountryCodeAndFlagSerializer
          .new(Country.all.sort_by { |c| c.name})
          .serializable_hash
      end


      def get_country_list
        country_list = []
        countries = Country.all.sort_by {|c| c.name}
        countries.each do |country_name|
          country_list << {
                        country_name: country_name.name,
                        country_code: country_name.country_code
                      }
        end
        render json: {country_list: country_list }
      end
    end
  end
end
