class Chat < ApplicationRecord
    belongs_to :app, counter_cache: true
    has_many(
        :messages,
        class_name: 'Message',
        foreign_key: 'chat_id',
        inverse_of: :chat,
        dependent: :destroy
      )
end
