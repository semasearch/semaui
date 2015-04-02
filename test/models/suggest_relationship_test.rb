# == Schema Information
#
# Table name: suggest_relationships
#
#  id                   :integer          not null, primary key
#  entity_instance_to   :string(255)
#  entity_instance_from :string(255)
#  relationship_type    :string(255)
#  url                  :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class SuggestRelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
