class RenameTableSearchHistories < ActiveRecord::Migration
  def change
    rename_table :search_histories, :searches
  end
end
