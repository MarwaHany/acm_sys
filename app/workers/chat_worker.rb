class ChatWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(application_id, application_token, chat_number)
    ActiveRecord::Base.connection_pool.with_connection do
      Chat.create!(
        number: chat_number,
        app_id: application_id,
        application_token: application_token,
      )
    end
  end
  end