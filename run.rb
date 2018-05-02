require 'intercom'
require 'time'
require './conversation_parser'
require './conversation_api'
require './conversation_file_writer'

@start_time = Time.now
@output_file_name = "#{@start_time.to_i}_panda_intercom.export"

@intercom = Intercom::Client.new(token: ENV["PANDA_INTERCOM_ACCESS_TOKEN"])
@conversation_parser = ConversationParser.new(@intercom, @output_file_name)
@conversation_api = ConversationApi.new(@intercom)
@conversation_file_writer = ConversationFileWriter.new()


puts ">>> --- Script started @ #{@start_time}"

# Get all conversations
conversations = @conversation_api.get_all_conversations()
parsed_conversations = @conversation_parser.parse_conversations(conversations)
@conversation_file_writer.write_conversations_to_file(parsed_conversations, @output_file_name, @start_time)

# Debug: Get one conversation
# conversation = @conversation_api.get_single_conversation(15993610078)
# parsed_conversation = @conversation_parser.parse_single_conversation(conversation)
# @conversation_file_writer.write_single_conversation_to_file(parsed_conversation, @output_file_name)

# Debug: list app tags to ensure API communication works
# @intercom.tags.all.map {|tag| tag.name }

puts ">>> --- Script ended @ #{Time.now}"