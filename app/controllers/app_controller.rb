class AppController < ApplicationController
    before_action :set_app, only: [:get, :get_chats, :update]
    skip_before_action :verify_authenticity_token
    
    def index
        @apps = App.all
        render json: AppBlueprint.render_as_hash(@apps)
    end 

    def get
        if @app.present?
            render json: AppBlueprint.render_as_hash(@app)
        else
            render json: {"message": " app %s does not exist." %params[:name]}.to_json, status: :not_found
        end
    end

    def get_chats
        if @app.present?
            chats = @app.chats
            render json: ChatBlueprint.render_as_hash(chats)
        else
            render json: {"message": " app does not exist."}.to_json
        end
    end

    def update
        if @app.present?
            if @app.update(app_params)
                render json: AppBlueprint.render_as_hash(@app)
            else
                render json: @application.errors, status: :unprocessable_entity
            end
        end
    end

    def app_params
        params.permit(:name)
    end

    def post
        @app = App.new(name: params[:name])
        begin
            @app.save
            render json: {"message": "new app %s was created" %params[:name]}.to_json, status: :created
        rescue    
            render json: {"error": "something wrong with the input"}.to_json, status: :bad_request
        end
    end

    def set_app
        @app = App.find_by(token: params[:token])
    end
end
