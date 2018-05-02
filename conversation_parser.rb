require 'nokogiri'
require './conversation_api'
require './user_api'

class ConversationParser
	attr_reader :intercom, :conversation_api, :user_api

	def initialize(client, output_file_name)
		@intercom = client
    @conversation_api = ConversationApi.new(intercom)   
		@user_api = UserApi.new(intercom)		
	end

  def parse_single_conversation(conversation)
    puts "Parsing conversation ##{conversation.id}"

    parsed = {
      id: conversation.id,
      parts_counter: conversation.conversation_parts.length,
      parts: parse_conversation_parts(conversation)
    }
    
    puts "Parsed conversation: #{parsed}"
    parsed
  end

  def parse_conversations(conversations)
    puts "Parsing #{conversations.count} conversations"
    conversations.collect do |conversation|
      parse_single_conversation(conversation)
    end
  end

  private

  def parse_conversation_parts(conversation)
    total_count = conversation.conversation_parts.length
    current_count = 0
    puts "Parsing #{total_count} parts for conversation ##{conversation.id}"

    conversation.conversation_parts.collect do |conversation_part|
      parse_conversation_part(conversation_part)
    end
  end

  def parse_conversation_part(conversation_part)
    puts "Parsing conversation part: #{conversation_part}"

    parsed = {
      type: conversation_part.part_type,
      author: get_part_author(conversation_part),
      body: parse_html_part(conversation_part.body)
    }

    puts "Parsed conversation part: #{parsed}"
    parsed
  end

  def get_part_author(conversation_part)
    puts "Parsing part author"
    author_id = conversation_part.author.id
    author_type = conversation_part.author.type

    parsed = case author_type
    when "admin"
      author = user_api.get_admin_by_id(author_id)
      puts "Found author: #{author}"

      {
        type: "admin",
        name: author.name,
        email: author.email
      }
    when "user"
      author = user_api.get_user_by_id(author_id)
      puts "Found author: #{author}"

      {
        type: "user",
        name: author.name,
        email: author.email
      }
    when "bot"
      {
        type: "bot",
        name: "bot",
        email: "bot"
      }
    end

    puts "Parsed author: #{parsed}"
    parsed
  end

  def parse_html_part(html)
  	Nokogiri::HTML(html).text
  end

end