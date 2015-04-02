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

require 'test_helper'

class RelationshipBitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
