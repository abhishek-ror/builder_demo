class SetupAdminUserRecord < ActiveRecord::Migration[6.0]
  def change
    account = AccountBlock::Account.new(first_name: "Admin", last_name: "User", phone_number: '', email: "systemadmin@gmail.com", activated: true, type: "EmailAccount", user_type: "individual", status: "regular", full_name: "System Admin User", password: "systemadmin")
    account.save(validate: false)
  end
end
