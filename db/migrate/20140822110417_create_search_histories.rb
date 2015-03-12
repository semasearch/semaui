class CreateSearchHistories < ActiveRecord::Migration
  def change
    create_table :search_histories do |t|
      t.string :search_for
      t.integer :user_id

      t.timestamps
    end
  end
end
