class User < ApplicationRecord
  attr_accessor :remember_token, :old_password, :crop_x, :crop_y, :crop_w, :crop_h

  mount_uploader :avatar, AvatarUploader
  after_update :crop_avatar

  before_save :downcase_email, if: Proc.new { |user| user.email? }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }, allow_nil: true
  validates :email, presence: true, length: { maximum: 255}, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, unless: proc{ |user| user.email.blank? }
  validates :password, length: { minimum: 6 }, allow_nil: true
    
  has_secure_password
  
  def downcase_email
    self.email = email.downcase
  end

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  class << self
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

    def find_by_omniauth(auth)
      user = User.find_by_provider_and_nickname(auth["provider"], auth["info"]["nickname"])
      user ? user : User.create_with_omniauth(auth)
    end

    def create_with_omniauth(auth)
      create! do |user|
        random_password = SecureRandom.hex(9)
        user.provider = auth["provider"]
        user.nickname = auth["info"]["nickname"]
        user.password = random_password
        user.password_confirmation = random_password
        user.name_en = auth["info"]["nickname"] + "-" +RandomCode.generate_name_uuid
      end
    end
  end
end
