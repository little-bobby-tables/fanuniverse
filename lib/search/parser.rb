require 'search/lexer'
require 'search/ast'

module Search
  class Parser
    def initialize(query, queryable_fields = [])
      @lexer = Lexer.new(query)
      @fields_regex = Regexp.union(queryable_fields)
    end

    delegate :match, :count, :skip, :match_regex, to: :@lexer

    # query                    = expression
    #                          ;
    # expression               = boolean clause , "," , expression
    #                          | boolean clause , "OR" , expression
    #                          | boolean clause
    #                          ;
    # boolean clause           = [ "NOT" ] , clause
    #                          ;
    # clause                   = parenthesized expression
    #                          | field term
    #                          | term
    #                          ;
    # parenthesized expression = "(" , expression , ")"
    #                          ;
    # field term               = field , ":" , safe string
    #                          ;
    # term                     = quoted string
    #                          | string with balanced parentheses
    #                          ;

    def ast
      expression
    end

    def expression
      left = boolean_clause
      operator = match :binary_operator

      skip :whitespace

      right = expression if operator

      if operator == ','
        Expression.new :and, left, right
      elsif operator == 'OR'
        Expression.new :or, left, right
      else
        left
      end
    end

    def boolean_clause
      negation = match :negation
      body = clause

      redundant_negation = negation && body.is_a?(NegatedClause)

      if redundant_negation
        body.body
      elsif negation
        NegatedClause.new body
      else
        body
      end
    end

    def clause
      parenthesized_expression || field_term || term
    end

    def parenthesized_expression
      opening_parens = count :left_parentheses

      if opening_parens
        body = expression
        closing_parens = count :right_parentheses

        if opening_parens == closing_parens
          body
        else
          # imbalanced parentheses
        end
      end
    end

    def field_term
      field = match_regex @fields_regex

      if field && skip(:term_delimiter)
        field_query = match_until :reserved

        FieldTerm.new field, field_query
      end
    end

    def term
      string = match_until :reserved

      Term.new string.strip
    end
  end
end
