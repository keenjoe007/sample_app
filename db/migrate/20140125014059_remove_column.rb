class RemoveColumn < ActiveRecord::Migration
  def change
    remove_columns :users, :pasword_digest
  end
end
