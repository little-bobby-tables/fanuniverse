# This file contains ActiveRecord extensions.

module ActiveRecordInstanceExtensions
  def reload(*)
    run_callbacks(:reload) { super }
  end
end

module ActiveRecordClassExtensions

end

class ApplicationRecord < ActiveRecord::Base
  prepend ActiveRecordInstanceExtensions # prepend to avoid gems overriding extended methods
  extend ActiveRecordClassExtensions

  define_model_callbacks :reload, only: [:after]

  self.abstract_class = true
end
