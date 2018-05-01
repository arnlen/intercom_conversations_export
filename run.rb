require 'intercom'
require 'time'
require './conversation_parser'
require './conversation_api'

@output_file_name = "#{Time.now.to_i}_panda_intercom.export"

@intercom = Intercom::Client.new(token: ENV["PANDA_INTERCOM_ACCESS_TOKEN"])
@conversation_parser = ConversationParser.new(@intercom, @output_file_name)
@conversation_api = ConversationApi.new(@intercom)


puts ">>> --- Script started @ #{Time.now}"

# Get all conversations
@conversation_parser.write_conversations_to_file()

# Get one conversation
# conversation = @conversation_api.get_single_conversation(1)
# @conversation_parser.parse_single_conversation(conversation)

# Debug: list app tags to ensure API communication works
# @intercom.tags.all.map {|tag| tag.name }

puts ">>> --- Script ended @ #{Time.now}"