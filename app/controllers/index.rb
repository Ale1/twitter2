get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)
  
 this_user = User.create!(:username => @access_token.params[:screen_name], :oauth_token => @access_token.token, :oauth_secret=> @access_token.secret)
 session[:user_id] = this_user.id
 erb :index
end


post '/tweet' do
   this_user = User.find(session[:user_id])

   Twitter.configure do |config|
   config.consumer_key = ENV['TWITTER_KEY']
   config.consumer_secret = ENV['TWITTER_SECRET']
   config.oauth_token = this_user.oauth_token
   config.oauth_token_secret = this_user.oauth_secret
 end
   Twitter.update(params[:mytweet])
end

