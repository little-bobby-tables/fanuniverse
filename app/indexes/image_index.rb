# frozen_string_literal: true

Elasticfusion.define Image do
  settings index: { number_of_shards: 1 } do
    mappings dynamic: false, _source: { enabled: false }, _all: { enabled: false } do
      indexes :id, type: 'integer'
      indexes :tag_names, type: 'keyword'
      indexes :suggested_by, type: 'keyword'
      indexes :starred_by_ids, type: 'keyword'
      indexes :created_at, type: 'date'
    end
  end

  def as_indexed_json(*)
    {
      id: id,
      tag_names: tag_names,
      suggested_by: suggested_by.name.downcase,
      starred_by_ids: Star.user_ids_for_resource(self),
      created_at: created_at
    }
  end

  elasticfusion do
    keyword_field :tag_names

    allowed_search_fields [:suggested_by, :created_at]
  end
end
