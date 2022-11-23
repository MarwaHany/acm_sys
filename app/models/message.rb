require 'elasticsearch/model'
class Message < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    validates :content, presence: true

    belongs_to :chat, counter_cache: true

    settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
        # do some mapping to the data; as data is always in the text form
        indexes :content, type: :text
        indexes :application_token, type: :text
        indexes :chat_id, type: :integer
        indexes :chat_number, type: :integer
        indexes :content, analyzer: 'english'
        indexes :created_at, type: :date, format: :date_optional_time
        indexes :updated_at, type: :date, format: :date_optional_time
        indexes :number, type: :integer
    end
    end
    def self.search(value, chat_number, token)
        __elasticsearch__.search(
            query: {
                bool: {
                must: [
                    {
                        match: {
                            content: value
                        }
                    },
                    {
                        match_phrase: {
                            application_token: token
                        }
                    }

                ],
                filter: [
                    { term: { 
                        chat_number: chat_number
                    } 
                },
                ]
                }
            },
            _source: ['content', 'number', 'application_token', 'chat_number']
            )
    end
      
end

# Delete the previous articles index in Elasticsearch
Message.__elasticsearch__.client.indices.delete index: Message.index_name rescue nil

# Create the new index with the new mapping
Message.__elasticsearch__.client.indices.create \
  index: Message.index_name,
  body: { settings: Message.settings.to_hash, mappings: Message.mappings.to_hash }

Message.import # for auto sync model with elastic search
