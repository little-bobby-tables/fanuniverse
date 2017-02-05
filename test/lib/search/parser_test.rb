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
    assert_equal expression(:and, term('pearl'), expression(:or, term('garnet'), term('amethyst'))),
                 query('pearl, garnet OR amethyst')

    assert_equal expression(:and, negated(term('pearl')), negated(term('steven'))),
                 query('NOT pearl, NOT steven')

    assert_equal expression(:or, negated(term('pearl')), negated(term('steven'))),
                 query('NOT pearl OR NOT steven')
  end

  test 'parenthesized expressions' do
    assert_equal expression(:or, term('pearl'), expression(:and, term('garnet'), term('amethyst'))),
                 query('pearl OR (garnet, amethyst)')
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
