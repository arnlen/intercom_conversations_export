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
    puts "Parsing conversion ##{conversation.id}"

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

  # ORIGINAL VERSIONS

  # def write_conversations_to_file
   #  # Need to check if there are multiple pages of conversations
   #  conversations = conversation_api.get_first_page_of_conversations

   #  # Set this to TRUE initially so we process the first page
   #  current_page = 1
   #  count = 1
   #  total = conversations["pages"]["per_page"] * conversations["pages"]["total_pages"]

   #  while current_page
   #    # Parse through each conversation to see what is provided via the list
   #    conversations["conversations"].each do |single_conversation|
   #      write_to_file("Exporting conversation #{count} of #{total}")
   #      puts "Exporting conversation #{count} of #{total}"
   #      parse_conversation_parts(conversation_api.get_single_conversation(single_conversation['id']))
   #      count +=1
   #    end

   #    puts "PAGINATION: page #{conversations['pages']['page']} of #{conversations["pages"]["total_pages"]}"
   #    write_to_file("PAGE #{conversations['pages']['page']}")
   #    current_page = conversations['pages']['next']
   #    conversations = conversation_api.get_next_page_of_conversations(conversations['pages']['next'])
   #  end

   #  write_footer_to_file
  # end

  # def parse_conversation_parts(conversation)
  #   total_count = conversation.conversation_parts.length
  #   current_count = 0

  #   write_top_separator
  #   write_to_file("------------- ------------- CONVERSATION #{conversation.id} START ------------- -------------\n\n")

  #   write_to_file("CONVERSATION ID: #{conversation.id}")
  #   write_to_file("NUM PARTS: #{total_count}")
  #   conversation.conversation_parts.each do |conversation_part|
  #     write_to_file("\n<-------- CONVERSATION PART #{current_count+=1} OF #{total_count} -------->\n")
  #     parse_conversation_part(conversation_part)
  #   end

  #   write_to_file("\n\n------------- ------------- CONVERSATION #{conversation.id} END ------------- -------------")
  #   write_bottom_separator
  # end

  # def parse_conversation_part(conversation_part)
  #   write_to_file("PART TYPE: #{conversation_part.part_type}")
  #   write_to_file("PART BODY:")
  #   write_to_file(parse_html_part(conversation_part.body))
  # end

  # def initialize_file
  # 	File.write(output_file_path, "")
  # 	puts "Writing output to #{Dir.pwd}/#{output_file_path}"
  # end

  # def write_to_file(content)
  # 	File.open(output_file_path, 'a+') do |f|
  # 		f.puts(content.to_s + "\n")
  # 	end
  # end

  # def write_header_to_file
  # 	write_top_separator
  # 	write_to_file("PANDA Intercom export archive script")
  # 	write_to_file("Started on: #{Time.now}")
  # 	write_to_file("By: Arnaud Lenglet (@arnlen)")
  # 	write_bottom_separator
  # end

  # def write_footer_to_file
  # 	write_top_separator
  # 	write_to_file("PANDA Intercom export completed")
  # 	write_to_file("Finished on: #{Time.now}")
  # 	write_bottom_separator
  # end

  # def write_top_separator
  # 	write_to_file("\n\n------------- ------------- ------------- -------------")
  # end

  # def write_bottom_separator
  # 	write_to_file("------------- ------------- ------------- ------------- ------------- -------------\n\n")
  # end

end