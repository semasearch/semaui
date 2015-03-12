class RelationshipType < ActiveRecord::Base
  
  searchkick text_start: ['name']
  has_many :relationships
  validates_uniqueness_of :name

end
