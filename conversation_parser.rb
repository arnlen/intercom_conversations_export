require 'json'

class ConversationParser
  attr_reader :intercom

  def initialize(client)
    @intercom = client
  end

  def parse_single_conversation(conversation)
    puts "<XXXXXXXXXXXXX CONVERSATION XXXXXXXXXXXXX>"
    puts JSON.pretty_generate(conversation)
    puts "<XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX>"
  end

  def parse_multiple_conversations(conversations)
  	# Parse through each conversation to see what is provided via the list
  	conversations["conversations"].each do |single_conversation|
  	  parse_single_conversation(single_conversation)
  	end
  end
end