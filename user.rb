class User

	FORMATTED_FLAIR_REGEX = /^([\w -]*) ?[:-] *(\d*) Succ?ess?ful (?:Trade|Exchange)/i
	FLAIR_REGEX = /Verified Exchanger/i

	def initialize(bot, username)
		@bot = bot

		@username = username
	end

	def give_flair
		options = {
			adjective: 'Verified Exchanger',
			num: 1
		}

		if flair?
			if match = FORMATTED_FLAIR_REGEX.match(flair_text)
				options[:adjective] = match[1]
				options[:num] = match[2].to_i + 1
			elsif flair_text =~ FLAIR_REGEX
				num = 2
			else
				log_failure
				return false
			end
		end

		self.flair = "#{options[:adjective]}: #{options[:num]} Successful Trade#{'s' if options[:num] > 1}"
	end

	private

	def log_failure
		text = "Failed to update flair for user #{@username}. Flair text didn't match regex. Flair text: #{flair_text}"
		@bot.logger.error text
		@bot.sub.send_message 'Failed to Update Flair', text
	end

	def flair=(flair_text)
		css_string = flair? ? flair[:flair_css_class] : ''
		@bot.sub.set_flair @username, :user, flair_text, css_string
	end

	def flair
		flair = @bot.sub.get_flairlist(name: @username).first
        flair if flair[:user].casecmp(@username) == 0
	end

	def flair_text
		flair[:flair_text] if flair?
	end

	def flair?
		!flair.nil? && !flair[:flair_text].nil? && flair[:flair_text].present?
	end
end
