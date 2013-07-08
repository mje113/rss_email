require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'blank user validation' do
    skip
    user = User.new
    refute user.valid?
  end

  test 'valid user validation' do
    skip
    user = User.new(email: 'sam@example.com', password: 'password', password_confirmation: 'password')
    assert user.save
  end
end
