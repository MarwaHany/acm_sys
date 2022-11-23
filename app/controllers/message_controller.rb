class MessageController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_chat, only: [:get, :post]
    before_action :set_message, only: [:update]
    protect_from_forgery with: :null_session
    skip_before_action :verify_authenticity_token

    def get
        if @chat.present?
                if params[:body].nil?
                    @messages = []
                  else
                    @messages = Message.search(params[:body], @chat.number, @chat.application_token)
                  end
            render json: @messages.to_json
        else
            render json: { "message": 'chat does not exist.' }, status: :not_found
        end
    end

    def update
        if @message.present?
            if @message.update(message_params)
                render json: MessageBlueprint.render_as_hash(@message), status: :accepted
            else
                render json: @message.errors, status: :unprocessable_entity
            end
        else
            render json: { "message": 'message does not exist.' }, status: :not_found
        end
    end

    def post
        if @chat.present?
            @message = @chat.messages.build(message_params)
            @message.number = new_message_number
            @message.content = params[:content]
            if @message.valid?
                MessageWorker.perform_async(@chat.application_token, @chat.id, @chat.number, @message.number, @message.content)
                render json: MessageBlueprint.render_as_hash(@message), status: :created
            else
                render json: @message.errors, status: :unprocessable_entity
            end
        else
            render json: { "message": 'chat does not exist.' }, status: :not_found
        end
    end

    def message_params
        params.permit(:content)
    end

    def new_message_number
        redis = RedisService.new
        redis.increment_counter("app_#{params[:application_token]}_chat#{@chat.number}_message_ready_number")
      end

    def set_chat
        @chat = Chat.find_by(number: params[:chat_number], application_token: params[:application_token])
        render json: { "message": 'chat does not exist.' }, status: :not_found unless @chat
    end

    def set_message
        @message = Message.find_by(number: params[:number],chat_number: params[:chat_number], application_token: params[:application_token])
    end
end
