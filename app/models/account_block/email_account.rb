module AccountBlock
  class EmailAccount < Account
    include Wisper::Publisher
    
    validates :email, presence: true
    after_create :create_profile_and_address

    def self.create_stripe_customers(account)
      stripe_customer = Stripe::Customer.create({
        email:  account.email
      })
      account.stripe_id = stripe_customer.id
      account.save
    end

    def create_profile_and_address
      BxBlockProfile::Profile.create(account_id: id)
      BxBlockAddress::Address.create(account_id: id)
    end

  end
end