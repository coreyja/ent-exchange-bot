require 'Redd'
require 'pry'


require './flair_request.rb'
require './user_flair_updater.rb'
require './logger.rb'

class EntExchangeBot
	def initialize(sub_name)
		@sub_name = sub_name
		@username = ENV["REDDIT_USERNAME"]

		@logger = EntExchangeLogger.new('bot.log', 10, 1024000)
		@logger.sub = sub
	end


	def do_flair
		logger.info "Started Flair Run at #{Time.now}"

		flair_requests.each(&:do)

		logger.info "Ended Flair Run at #{Time.now}"

		nil
	end

	def name
		'the EntExchange FlairBot'
	end

	def username
		@username
	end

	def username_mention
		"/u/#{username}"
	end

	def sub
		@sub ||= r.subreddit_from_name @sub_name
	end

	def get_user(username)
		r.user_from_name username
	end

	def logger
		@logger
	end

	private
	
	def r
		if @r.nil?
			@r = Redd.it(:script, ENV["REDDIT_CLIENT_ID"], ENV["REDDIT_SECRET"], ENV["REDDIT_USERNAME"], ENV["REDDIT_PASSWORD"], user_agent: "EntExhcangeBot v0.0.1")
			@r.authorize!
		end
		@r
	end

	def flair_post
		@flair_post ||= sub.search('Sticky: Flair guide! Post your transactions here for Flair!', sort: :new, limit: 1).first
	end

	def flair_requests
		@flair_requests ||= flair_post.comments.map do |comment|
			FlairRequest.new(self, comment) if comment.body =~ /^flair request/i
		end.compact
	end
end
