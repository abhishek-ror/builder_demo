ActiveAdmin.register BxBlockReviews::AppReview, as: "Ratings" do
    
    actions :all, :except => [:new, :edit, :destroy, :show]
    
    index do 
        id_column
        column :account do |record|
          link_to("#{record&.account&.full_name}","/admin/accounts/#{record&.account&.id}") 
        end
        column :rating
        column :description
        column :created_at
    end
end