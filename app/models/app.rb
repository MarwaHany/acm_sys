class App < ApplicationRecord
    has_many(
        :chats,
        class_name: 'Chat',
        foreign_key: 'app_id',
        inverse_of: :app,
        dependent: :destroy
      )
    has_secure_token
    has_secure_token :token, length: 36
end
