class AddFkCols < ActiveRecord::Migration[7.0]
  def change
    add_reference :chats, :app, foreign_key: true, nullable: false
    add_reference :messages, :chat, foreign_key: true, nullable: false
  end
end
