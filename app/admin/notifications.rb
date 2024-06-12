ActiveAdmin.register BxBlockPushNotifications::PushNotification, as: "Notifications"do
    menu false

  actions :all, :except => [:edit]
  
  scope("All") { |scope| scope.where(account_id: current_admin_user.id) }
  scope("Unread") { |scope| scope.where(account_id: current_admin_user.id, is_read: [false, nil]) }
  scope("Read") { |scope| scope.where(account_id: current_admin_user.id, is_read: true) }
  
  #filter :created_by, as: :select, collection: proc { AccountBlock::Account.select(:id, :full_name) }
  filter :created_at
  filter :updated_at

  collection_action :mark_read, method: :put do
  end
  collection_action :mark_as_unread, method: :put do
  end

  collection_action :mark_all_read, method: :get do
    BxBlockPushNotifications::PushNotification.where(account_id: current_admin_user.id, is_read: [nil, false]).update_all(is_read: true)
    redirect_to admin_notifications_path, notice: 'Updated Successfully'
  end

  action_item :mark_all_read do
    link_to 'Mark All Read', mark_all_read_admin_notifications_path
  end

  controller do
    def scoped_collection
      BxBlockPushNotifications::PushNotification.where(account_id: current_admin_user.id)
    end
  end
  index do
    selectable_column
    column :contents
    column :created_at
    column :updated_at

    actions defaults: true do |_notification|
      if !_notification&.is_read?
        link_to 'mark as read', mark_read_admin_notifications_path(id: _notification.id), method: :put
      else
        link_to 'mark as unread', mark_as_unread_admin_notifications_path(id: _notification.id), method: :put
      end
    end
  end

  show do
    attributes_table do
      row 'Created By' do
        resource&.created_user&.full_name
      end
      row :contents
      row :created_at
      row :updated_at
    end
  end

  controller do
    def show
      resource.update(is_read: true)
    end

    def mark_read
      resource.update(is_read: true)
      redirect_to admin_notifications_path, notice: 'Updated Successfully'
    end

    def mark_as_unread
      resource.update(is_read: false)
      redirect_to admin_notifications_path, notice: 'Updated Successfully'
    end
  end

end
