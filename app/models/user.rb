class User < ActiveRecord::Base

  def fetch_tweets!
    Twitter.user_timeline(self.username, :count => 12).each do |tweet|
      self.tweets << Tweet.create!(:content => tweet.text) 
    end
  end

end