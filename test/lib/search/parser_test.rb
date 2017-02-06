require 'test_helper'
require 'search/parser'

class SearchParserTest < ActiveSupport::TestCase
  test 'single terms' do
    assert_equal term('peridot'),
                 query('peridot')

    assert_equal negated(term('lapis lazuli')),
                 query('NOT lapis lazuli')
  end

  test 'single conjunction and disjunction' do
    assert_equal expression(:and, term('peridot'), term('lapis lazuli')),
                 query('peridot, lapis lazuli')

    assert_equal expression(:or, term('peridot'), term('lapis lazuli')),
                 query('peridot OR lapis lazuli')
  end

  test 'operator precedence and associativity' do
    assert_equal expression(:and, term('pearl'), expression(:or, term('ruby'), term('sapphire'))),
                 query('pearl, ruby OR sapphire')

    assert_equal expression(:and, negated(term('pearl')), negated(term('ruby'))),
                 query('NOT pearl, NOT ruby')

    assert_equal expression(:or, negated(term('pearl')), negated(term('ruby'))),
                 query('NOT pearl OR NOT ruby')
  end

  test 'parenthesized expressions' do
    assert_equal expression(:or, term('pearl'), expression(:and, term('ruby'), term('sapphire'))),
                 query('pearl OR (ruby, sapphire)')
  end

  test 'nested parenthesized expressions' do
    assert_equal expression(:or, term('pearl'),
                            expression(:and, term('nested'),
                                       negated(expression(:or, negated((expression(:and, term('ruby'),
                                                                                   term('sapphire')))),
                                                          term('pearl'))))),
                 query('pearl OR (nested, NOT (NOT (ruby, sapphire) OR pearl))')
  end

  test 'complex string terms' do
    # string with balanced parentheses
    assert_equal expression(:or, term('pearl (yellow diamond)'),
                                 expression(:and, term('pearl (blue diamond)'), term('pearl'))),
                 query('pearl (yellow diamond) OR (pearl (blue diamond), pearl)')

    # quoted string
    assert_equal expression(:or, term('"quoted" string'),
                            expression(:and, term('pearl'), term('string with special characters =('))),
                 query('"\"quoted\" string" OR (pearl, "string with special characters =(")')
  end

  # Helpers

  def query(string)
    Search::Parser.new(string).ast
  end

  def expression(op, left, right)
    Search::Expression.new(op, left, right)
  end

  def term(body)
    Search::Term.new(body)
  end

  def negated(body)
    Search::NegatedClause.new(body)
  end
end
