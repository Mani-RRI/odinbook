module UsersHelper

  def get_status receiver_id
    (receiver_id.to_s == current_user.id.to_s) ? "Status" : "Post"
  end

  def get_placeholder receiver_id
    (receiver_id.to_s == current_user.id.to_s) ? "What's on your mind?" : 
                                                 "Write something..."
  end

  def friend_status_of(user, is_index)
    return if current_user == user
    if current_user.has_friend_request_from?(user)
      render "users/request_received", user: user, is_index: is_index
    elsif user.has_friend_request_from?(current_user)
      render "users/request_sent"
    elsif current_user.friends_with?(user)
      render "users/unfriend", user: user, is_index: is_index
    else
      render "users/add_friend", user: user, is_index: is_index
    end
  end

  def get_friendship(user1, user2)
    user1.friendships.find_by(friended_id: user2.id, accepted: true) ||
      user2.friendships.find_by(friended_id: user1.id, accepted: true)
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def image_for(user, options = { size: 50, img_class: "mid-img" })
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    title     = options[:title] || ""
    img_class = options[:img_class] || "mid-img"
    size = case img_class
           when "v-lg-img" then 160
           when "lg-img"   then 75
           when "md-img"   then 40
           when "sm-img"   then 32
           when "v-sm-img" then 19
           else options[:size] || 50
           end

    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: "#{user.name}'s profile picture", 
                            class: img_class, title: title)
  end
  
end
