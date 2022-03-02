class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 },
    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, on: :create
  
  before_validation { email.downcase! }

  before_update :hold_admin_update
  before_destroy :hold_admin_destroy

  has_secure_password

  has_many :tasks, dependent: :destroy

  private

  def hold_admin_destroy
    throw(:abort) if self.admin? && (User.where(admin: true).count <= 1)
  end

  def hold_admin_update
    #raise
    throw(:abort) if (self.admin == false) && (User.where(admin: true).count <= 1)
  end
end
