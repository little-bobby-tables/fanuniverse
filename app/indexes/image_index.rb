# frozen_string_literal: true

Elasticfusion.define Image do
  settings index: { number_of_shards: 1 } do
    mappings dynamic: false, _source: { enabled: false }, _all: { enabled: false } do
      indexes :id, type: 'integer'
      indexes :tag_names, type: 'keyword'
      indexes :stars, type: 'integer'
      indexes :width, type: 'integer'
      indexes :height, type: 'integer'
      indexes :suggested_by, type: 'keyword'
      indexes :starred_by_ids, type: 'keyword'
      indexes :created_at, type: 'date'
      indexes :processed, type: 'boolean'
    end
  end

  def as_indexed_json(*)
    {
      id: id,
      tag_names: tag_names,
      stars: star_count,
      width: width,
      height: height,
      suggested_by: suggested_by.name.downcase,
      starred_by_ids: stars.pluck(:user_id),
      created_at: created_at,
      processed: processed?
    }
  end

  elasticfusion do
    # +starred_by_ids+ and +stars+ are updated in StarsController
    reindex_when_updated [:tag_names, :processed]

    keyword_field :tag_names

    searchable_fields [:stars, :width, :height, :suggested_by, :created_at]

    default_sort created_at: :desc

    scopes do
      {
        processed: -> { { term: { processed: true } } }
      }
    end
  end
end
