class AddPaymentInvoiceStatusVehicleInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_inspections, :instant_deposit_status, :integer, default: 0
    add_column :vehicle_inspections, :final_invoice_status, :integer, default: 0
  end
end
