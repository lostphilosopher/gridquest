class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :game
  has_one :meta

  after_create :add_meta_to_user

  def admin?
    (email && (email == 'wandersen02@gmail.com'))
  end

  private

  def add_meta_to_user
    update(meta: Meta.create)
  end
end
