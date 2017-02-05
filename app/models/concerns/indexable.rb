require 'elasticsearch/model'

module Indexable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include "#{name}Index".constantize

    after_commit(on: [:create, :update]) do
      __elasticsearch__.index_document
    end

    after_commit(on: :destroy) do
      __elasticsearch__.delete_document
    end
  end
end
