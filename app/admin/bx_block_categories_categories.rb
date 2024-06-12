ActiveAdmin.register BxBlockCategories::Category, as: "Category" do
 
  permit_params :name, :optional, sub_categories_attributes: [:id, :name, :_destroy]

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :created_at

  form do |f|
    f.inputs do
      f.inputs "Category" do
        f.input :name
        f.input :optional
      end
      f.inputs "Sub Category" do
        f.has_many :sub_categories, accepts_nested_attributes_for: true, new_record: true do |sc|
          sc.input :name
          sc.input :_destroy, :as => :boolean
        end
      end  
    end
    f.actions
  end

  show do |category|
    @sub_categories = category.sub_categories
    attributes_table do
      row :id
      row :name
      row :created_at
      row :updated_at
      row :optional
      panel "Sub categories (Total Count: #{@sub_categories.count})" do
        if @sub_categories.present?
          table_for @sub_categories do
            column :id 
            column :name
            column :created_at
            column :updated_at
          end
        end
      end
    end
  end
end
