require 'json'
require 'intercom'
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
end

class ConversationSetup
  attr_reader :intercom, :conversation_parser

  def initialize(access_token)
    # You should alwasy store you access token in a environment variable
    # This ensures you never accidentally expose it in your code
    @intercom = Intercom::Client.new(token: ENV["PANDA_INTERCOM_ACCESS_TOKEN"])
    @conversation_parser = ConversationParser.new(intercom)
  end

  def get_all_conversations
    # Get the first page of your conversations
    conversations = intercom.get("/conversations", "")
    conversations
  end

  def run
    result = get_all_conversations
    # Parse through each conversation to see what is provided via the list
    result["conversations"].each do |single_conversation|
      conversation_parser.parse_single_conversation(single_conversation)
    end

  end
end

ConversationSetup.new("AT").run