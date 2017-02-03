require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test 'converts tag stringS to sanitized tag names arrays' do
    input = '  ,      , tag ONE,taG   tWO ,  '
    expected = ['tag one', 'tag two']

    assert_equal expected, Tag.string_to_names(input)
  end
end
