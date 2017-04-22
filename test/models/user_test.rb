# frozen_string_literal: true
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'gets a profile on creation' do
    user = User.create! name: 'Peridot',
                        password: 'password', email: 'dot@lowlyearthtech.com'
    assert Profile.exists? user_id: user.id
  end
end
