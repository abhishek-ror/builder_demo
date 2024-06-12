module BxBlockOrdercreation3
  class OrderRequestStatusClosedWorker
    include Sidekiq::Worker

    def perform(id, type)
      if type == "buy_request"     
      	order = BxBlockVehicleShipping::VehicleOrder.find_by(id: id)
      else
      	order = BxBlockOrdercreation3::CarOrder.find_by(id: id)
	  end
      if ((order.status_updated_at.utc) + 48.hours) < Time.now
        order.update(status: "closed") if order.status == "pending"
      end
    end
  end
end