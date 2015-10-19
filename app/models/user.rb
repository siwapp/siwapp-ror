class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true, format: {with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: "Only valid emails"}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end
