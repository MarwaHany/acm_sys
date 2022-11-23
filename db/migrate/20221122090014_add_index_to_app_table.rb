class AddIndexToAppTable < ActiveRecord::Migration[7.0]
  def change
    add_index :apps, :token
  end
end
