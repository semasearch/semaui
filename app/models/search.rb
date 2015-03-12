class Search < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :search_for
  default_scope -> {order('created_at desc')}
end
