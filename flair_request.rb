class FlairRequest

	LINK_REGEX = /^link\s*[:=]?\s*(.+)/i
	EXCHANGER_REGEX = /^(?:trade(?:d|r)|exchange(?:d|r))(?: with)?\s*[:=]?\s*(?:\/?u\/)?(.+)/i

	def initialize(comment)
		raise 'Comment can not be parsed as a Flair Request' unless comment.body =~ /^flair request/i
		@link = LINK_REGEX.match(comment.body)[1]
		@exchanger = EXCHANGER_REGEX.match(comment.body)[1]
	end
end
