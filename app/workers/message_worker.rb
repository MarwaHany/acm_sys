class MessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(application_token, chat_id, chat_number, message_number, body)
      ActiveRecord::Base.connection_pool.with_connection do
        Message.create!(
          number: message_number,
          chat_id: chat_id,
          chat_number: chat_number,
          application_token: application_token,
          content: body,
        )
      end
    end
  end