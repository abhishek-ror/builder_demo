class AddInvoiceAmountInVehicleShipping < ActiveRecord::Migration[6.0]
  def change
    add_column :vehicle_shippings, :invoice_amount, :integer
  end
end
