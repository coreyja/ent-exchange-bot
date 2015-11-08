class FlairRequest

	LINK_REGEX = /^link\s*[:=]?\s*(.+)/i
	EXCHANGER_REGEX = /^(?:trade(?:d|r)|exchange(?:d|r))(?: with)?\s*[:=]?\s*(?:\/?u\/)?(.+)/i

	CONFIRMED_REGEX = /confirmed/i
	CONFIRMATION_REQUESTED_REGEX = /thank you for submitting a flair request/
	COMPLETE_REGEX = /Flair Request Completed!/

	def initialize(bot, comment)
		raise 'Comment can not be parsed as a Flair Request' unless comment.body =~ /^flair request/i
		@link = LINK_REGEX.match(comment.body)[1]
		@exchanger = EXCHANGER_REGEX.match(comment.body)[1]
		@requester = comment.author

		@comment = comment
		@bot = bot
	end

	def do
		unless complete?
			request_confirmation unless confirmed? || confirmation_requested?
			complete if confirmed?
		end
	end

	def request_confirmation
		 @comment.reply confirmation_request_comment_text
	end

	def complete
		give_flair
		@comment.reply complete_comment_text
	end

	def give_flair
		# TODO: Leaving this till last so I can get all the states correct first
	end

	def confirmation_request
		@comment.replies.select do |reply|
			reply.body =~ CONFIRMATION_REQUESTED_REGEX && reply.author == @bot.username
		end.first
	end

	# ???? Huh Methods

	def confirmation_requested?
		!confirmation_request.nil?
	end

	def confirmed?
		replies_to_search.map do |reply|
			reply.body =~ CONFIRMED_REGEX && reply.author == @exchanger
		end.compact.any?
	end

	def complete?
		@comment.replies.map do |reply|
			reply.body =~ COMPLETE_REGEX && reply.author == @bot.username
		end.compact.any?
	end

	private

	def replies_to_search
		replies = @comment.replies
		replies += confirmation_request.replies if confirmation_requested?
		replies
	end

	def confirmation_request_comment_text
		%Q(
I am #{@bot.username_mention}, thank you for submitting a flair request.

To complete this flair request I need to have the exchanger, /u/#{@exchanger}, comment here to confirm the trade.

/u/#{@exchanger}, please simply reply to either this comment or the parent comment, with the word "Confirmed" to confirm the trade took place and was successful.

Once this trade is confirmed I will give both parties flair. 

Thanks!

-- #{@bot.username_mention}
		)
	end

	def complete_comment_text
		%Q(
Flair Request Completed!

Flair has been added, or updated, for both /u/#{@requester} and /u/#{@exchanger}.

Thank you!

-- #{@bot.username_mention}
		)
	end
end
