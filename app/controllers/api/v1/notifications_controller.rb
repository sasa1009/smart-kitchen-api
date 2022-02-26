class Api::V1::NotificationsController < ApplicationController
  def index
    current_user = current_api_v1_user
    if !current_user
      raise "You need to sign in or sign up before continuing."
    end

    notifications = Notification.connection.select_all("
      SELECT
        notifications.sender_id,
        users.name AS sender_name,
        users.image_url AS sender_image_url,
        notifications.recipe_id,
        recipes.title AS recipe_title
      FROM notifications
      LEFT JOIN users
      ON notifications.sender_id = users.id
      LEFT JOIN recipes
      ON notifications.recipe_id = recipes.id
      WHERE notifications.user_id = #{current_user[:id]}
      ORDER BY notifications.created_at DESC
      LIMIT #{params[:limit].to_i}
      OFFSET #{params[:offset].to_i}")

    count = Notification.where(user_id: current_user[:id]).count

    response_data = {
      notifications: [],
      meta: {
        total: count
      }
    }

    for notification in notifications do
      response_data[:notifications].push({
        sender_id: notification['sender_id'],
        sender_name: notification['sender_name'],
        sender_image_url: notification['sender_image_url'],
        recipe_id: notification['recipe_id'],
        recipe_title: notification['recipe_title'],
      })
    end

    render json: response_data
  end
end
