require 'intercom'
require './conversation_parser'
require './conversation_api'


@intercom = Intercom::Client.new(token: ENV["PANDA_INTERCOM_ACCESS_TOKEN"])
@conversation_parser = ConversationParser.new(@intercom)
@conversation_api = ConversationApi.new()

# Get all conversations
# conversations = @conversation_api.get_all_conversations()
# @conversation_parser.parse_multiple_conversations(conversations)

# Get one conversation
# conversation = @conversation_api.get(1)
# @conversation_parser.parse_single_conversation(conversation)

# Debug: list app tags to ensure API communication works
@intercom.tags.all.map {|tag| tag.name }