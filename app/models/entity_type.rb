# == Schema Information
#
# Table name: entity_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class EntityType < ActiveRecord::Base
  searchkick text_start: ['name']
  has_many :relationships
  validates_uniqueness_of :name
end
