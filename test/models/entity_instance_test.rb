# == Schema Information
#
# Table name: entity_instances
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  node_id        :string(255)
#  entity_type_id :integer
#  user_id        :integer
#

require 'test_helper'

class EntityInstanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
