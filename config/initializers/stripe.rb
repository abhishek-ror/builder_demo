Rails.configuration.stripe = {
  publishable_key: 'pk_test_51Lhq4vSBknqbWkakpXLku5ljFvfp3gCNQJcetoAUx44peDNo2VCDWOLHaQUdH6Y873NUE6bPB51Xtn9LudkeGaH40024mmF0IU',
  secret_key: 'sk_test_51Lhq4vSBknqbWkakvX6OzD95hTS02cxCPWAdrYknaJN3XYasAPEwRabwxBPl9XmEUkYKzQCaJoS6q60zxEPDAe4Y002TlKaz2t'
}
 
Stripe.api_key = Rails.configuration.stripe[:secret_key]
 
# StripeEvent.configure do |events|
#   events.subscribe 'charge.succeeded' do |event|
#     # Here you can send notification to user,
#     # change transaction state or whatever you want.
#   end

#   events.subscribe 'payment_intent.succeeded' do |event|
    
#   end
# end