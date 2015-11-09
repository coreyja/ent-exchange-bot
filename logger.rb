require 'logger'

class EntExchangeLogger < Logger

	def sub=(sub)
		@sub=sub
	end

	def error(text)
		super text
		@sub.send_message 'Error Updating Flair', text if @sub
	end
end