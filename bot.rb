require 'Redd'
require 'pry'

require './flair_request.rb'

class EntExchangeBot
	def initialize(sub_name)
		@sub_name = sub_name
	end

	def r
		if @r.nil?
			@r = Redd.it(:script, ENV["REDDIT_CLIENT_ID"], ENV["REDDIT_SECRET"], ENV["REDDIT_USERNAME"], ENV["REDDIT_PASSWORD"], user_agent: "EntExhcangeBot v0.0.1")
			@r.authorize!
		end
		@r
	end

	def sub
		@sub ||= r.subreddit_from_name @sub_name
	end

	def flair_post
		@flair_post ||= sub.search('Sticky: Flair guide! Post your transactions here for Flair!', sort: :new, limit: 1).first
	end

	def flair_requests
		@flair_requests ||= flair_post.comments.map do |comment|
			FlairRequest.new(comment) if comment.body =~ /^flair request/i
		end.compact
	end
end

binding.pry
