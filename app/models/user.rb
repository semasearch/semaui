class User < ActiveRecord::Base
  rolify
  has_many :searches
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :set_role

  default_scope -> {order('created_at desc')}
  scope :confirmed, -> {where('invitation_token IS NULL')}
  scope :unconfirmed, -> {where('invitation_token IS NOT NULL')}

  def initials
    initials = name ? name : email
  end

  private
    def set_role
      add_role 'member'
    end
end
