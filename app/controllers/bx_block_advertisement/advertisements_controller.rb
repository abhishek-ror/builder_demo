module BxBlockAdvertisement
	class AdvertisementsController < ApplicationController

		def advertisement_lists
			ads = BxBlockAdvertisement::Advertisement.all
			if ads.present?
				render json: {Advertisements: BxBlockAdvertisements::AdvertisementSerializer.new(ads)}
			else
				render json: {Message: "No Advertisement available"}
			end
		end
	end
end
