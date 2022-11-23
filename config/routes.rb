Rails.application.routes.draw do
  
  require  'sidekiq/web'
  mount Sidekiq::Web, at: "/sidekiq"
  get "/app/show", to: "app#index"
  get "/app/search", to: "app#get"
  post "/create/app", to: "app#post"
  get "/app/chats", to: "app#get_chats"
  put "/update/app/name", to: "app#update"

  get "/chat/messages", to: "chat#get_messages"
  post "/create/chat", to: "chat#post"
  
  post "/create/message", to: "message#post"
  get "/message/show", to:"message#get"
  put "/update/message/content", to:"message#update"
  
  root "home#index"
end
