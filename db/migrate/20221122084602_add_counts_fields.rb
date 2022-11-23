class AddCountsFields < ActiveRecord::Migration[7.0]
  def change
    add_column :apps, :chats_count, :integer, default: 0
    add_column :chats, :messages_count, :integer, default: 0
  end
end
