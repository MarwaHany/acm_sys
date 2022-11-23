class ChatController < ApplicationController
    before_action :set_app, only: [:post]
    before_action :set_chat, only: [:get, :get_messages]
    # protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    def get
        render json: ChatBlueprint.render_as_hash(@chat)
    end

    def post
      @chat = @app.chats.build
      @chat.number = new_chat_number
      if @chat.valid?
        ChatWorker.perform_async(@app.id, @app.token, @chat.number)
        render json: ChatBlueprint.render_as_hash(@chat), status: :created
      else
        render json: @chat.errors, status: :unprocessable_entity
      end
    end

    def get_messages
      if @chat.present? 
          msgs = @chat.messages
          render json: MessageBlueprint.render_as_hash(msgs)
      else
          render json: {"message": " chat does not exist."}.to_json
      end
    end

    # SETTERS
    def new_chat_number
        redis = RedisService.new
        redis.increment_counter("app_#{@app.token}_chat_ready_number")
    end

    def set_chat
        @chat = Chat.find_by(number: params[:chat_number], application_token: params[:application_token])
        render json: { error: 'Chat Not Found' }, status: 404 unless @chat
    end
    def set_app
        @app = App.find_by(token: params[:application_token])
      end
end
