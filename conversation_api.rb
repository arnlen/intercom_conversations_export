require 'intercom'

class ConversationApi
  attr_reader :intercom, :conversation_parser

  def initialize
    # You should alwasy store you access token in a environment variable
    # This ensures you never accidentally expose it in your code
    @intercom = Intercom::Client.new(token: ENV["PANDA_INTERCOM_ACCESS_TOKEN"])
    @conversation_parser = ConversationParser.new(intercom)
  end

  def get(conversation_id)
    intercom.conversations.find(id: conversation_id)
  end

  def get_all_conversations
    # Get the first page of your conversations
    conversations = intercom.get("/conversations", "")
  end

end