class User < ActiveRecord::Base
  has_many :posts
  has_many :comments, through: :posts

  scope :admin, -> { where(admin: true) }
  scope :named, ->(name) { where(name: name) }
  scope :older_than, ->(age, min_posts) {
    where("age > ?", age).where(id: Post.group(:user_id).having("COUNT(*) >= ?", min_posts).select(:user_id))
  }
end

class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  scope :published, -> { where(published: true) }
end

class Comment < ActiveRecord::Base
  belongs_to :post
end
