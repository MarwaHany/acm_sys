class AddNumberingIndeces < ActiveRecord::Migration[7.0]
  def change
    add_index :chats, :number, unique: true
    add_index :messages, :number, unique: true
  end
end
