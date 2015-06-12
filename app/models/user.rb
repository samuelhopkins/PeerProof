class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role
  has_one :paper
  before_create :set_default_role
   # validates :email,
   #  :format   => {
   #    :with => /\A.+@(.+\.)*(edu)\z/i,
   #    :message => 'must be an valid student email address'
   #  }

  private
  def set_default_role
  	self.role ||= Role.find_by_name('registered')
  	self.credits=1
  end
end
