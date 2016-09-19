class CommentsController < ApplicationController
  USER_KEY = :user
  TEXT_KEY = :text
  TIMESTAMP_KEY = :timestamp
  MAX_COMMENTS_TO_LOAD = 150

  def create
    raise ArgumentError, 'Incorrect post submitted' unless params.key?(:request)
    comment = params[:request].symbolize_keys
    validate_comment_params(comment)
    comment[USER_KEY] = User.find(comment[USER_KEY])
    comment[TIMESTAMP_KEY] = convert_time(comment[TIMESTAMP_KEY])
    Comment.create!(comment)

    render json: { response: 'Success' }
  end

  def show
    comments = []
    Comment.order('id desc').limit(MAX_COMMENTS_TO_LOAD).each do |c|
      tmp = c.as_json
      tmp[TIMESTAMP_KEY] = c[TIMESTAMP_KEY].to_f * 1000
      tmp['user_name'] = User.find(c['user_id']).name
      comments.unshift(tmp) # Ensure earlier comments appear at top
    end
    render json: comments
  end

  def validate_comment_params(params)
    validate_all_parameters([USER_KEY, TEXT_KEY, TIMESTAMP_KEY], params)
    validate_user(params[USER_KEY])
  end

  def validate_user(user)
    raise ArgumentError, 'User does not exist' unless User.find(user)
  end

  private

  def comment_params
    params.permit(:user, :timestamp, :text)
  end

  def convert_time(js_time)
    Time.zone.at(js_time.to_i / 1000.0)
  end
end
