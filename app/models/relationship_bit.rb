# == Schema Information
#
# Table name: relationship_bits
#
#  id              :integer          not null, primary key
#  url             :text
#  comment         :text
#  fulltext        :text
#  relationship_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class RelationshipBit < ActiveRecord::Base
  belongs_to :relationship
end
