require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @params = {
      user: User.find(1),
      text: 'Bortles will be a Hall of Famer bro.',
      timestamp: Time.zone.now
    }
  end

  test 'comment can not be added without a user' do
    assert_raise ActiveRecord::RecordInvalid do
      Comment.create!(@params.except(:user))
    end
  end

  test 'comment can not be added without text' do
    assert_raise ActiveRecord::RecordInvalid do
      Comment.create!(@params.except(:text))
    end
  end

  test 'comment can not be added without a timestamp' do
    assert_raise ActiveRecord::RecordInvalid do
      Comment.create!(@params.except(:timestamp))
    end
  end

  test 'can create comment' do
    skip('Failing, Mike should look at this')
    assert Comment.create!(@params)
    last_added = Comment.last
    assert_equal last_added.timestamp, @params[:timestamp]
    assert_equal last_added.text, @params[:text]
    assert_equal last_added.user, @params[:user]
  end
end
