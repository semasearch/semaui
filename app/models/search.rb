# == Schema Information
#
# Table name: searches
#
#  id         :integer          not null, primary key
#  search_for :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Search < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :search_for
  default_scope -> {order('created_at desc')}
end
