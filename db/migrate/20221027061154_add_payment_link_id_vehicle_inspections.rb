class AddPaymentLinkIdVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :stripe_payment_link_id, :string
    add_column :vehicle_inspections, :payment_link_active, :integer

    add_column :shipments, :stripe_payment_link_id, :string
    add_column :shipments, :payment_link_active, :integer
  end
end
