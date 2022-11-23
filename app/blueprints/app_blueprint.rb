class AppBlueprint < Blueprinter::Base
    identifier :token

    fields :name, :chats_count
  end
  