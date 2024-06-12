module BxBlockAdmin
  class ApplicationController < BuilderBase::ApplicationController
    before_action :set_active_storage_host

    def set_active_storage_host
      return unless ActiveStorage::Current.host.blank?
      if Rails.env == 'test'
        ActiveStorage::Current.host = 'http://localhost:3000'
      else
        ActiveStorage::Current.host = request.host
      end
    end
    # protect_from_forgery with: :exception
  end
end
