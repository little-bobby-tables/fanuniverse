module Search
  class Expression < Struct.new(:op, :left, :right)
  end

  class NegatedClause < Struct.new(:body)
  end

  class FieldTerm < Struct.new(:field, :query)
  end

  class Term < Struct.new(:body)
  end
end
