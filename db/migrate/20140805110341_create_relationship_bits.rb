class CreateRelationshipBits < ActiveRecord::Migration
  def change
    create_table :relationship_bits do |t|
      t.text :url
      t.text :comment
      t.text :fulltext
      t.references :relationship, index: true

      t.timestamps
    end
  end
end
