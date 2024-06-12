class ChangeFinalInvoicePaymentStatusDatatype < ActiveRecord::Migration[6.0]
  def change
    change_column :car_orders, :final_invoice_payment_status, :integer, :using => 'case when final_invoice_payment_status then 0 else 1 end'
  end
end
