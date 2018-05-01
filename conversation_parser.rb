require 'json'
require 'time'
require 'nokogiri'
require './conversation_api'

class ConversationParser
	attr_reader :intercom, :output_file_path, :conversation_api

	def initialize(client, output_file_name)
		@intercom = client
		@output_file_path = "conversation_exports/#{output_file_name}"
		@conversation_api = ConversationApi.new(intercom)

		initialize_file
		write_header_to_file
	end

  def write_conversations_to_file
	  # Need to check if there are multiple pages of conversations
	  conversations = conversation_api.get_first_page_of_conversations

	  # Set this to TRUE initially so we process the first page
	  current_page = 1
	  count = 1
	  total = conversations["pages"]["per_page"] * conversations["pages"]["total_pages"]

	  while current_page
	    # Parse through each conversation to see what is provided via the list
	    conversations["conversations"].each do |single_conversation|
	      write_to_file("Exporting conversation #{count} of #{total}")
	      puts "Exporting conversation #{count} of #{total}"
	      parse_conversation_parts(conversation_api.get_single_conversation(single_conversation['id']))
	      count +=1
	    end

	    puts "PAGINATION: page #{conversations['pages']['page']} of #{conversations["pages"]["total_pages"]}"
	    write_to_file("PAGE #{conversations['pages']['page']}")
	    current_page = conversations['pages']['next']
	    conversations = conversation_api.get_next_page_of_conversations(conversations['pages']['next'])
	  end

	  write_footer_to_file
  end

  private

  def parse_conversation_parts(conversation)
    total_count = conversation.conversation_parts.length
    current_count = 0

    write_top_separator
    write_to_file("------------- ------------- CONVERSATION #{conversation.id} START ------------- -------------\n\n")

    write_to_file("CONVERSATION ID: #{conversation.id}")
    write_to_file("NUM PARTS: #{total_count}")
    conversation.conversation_parts.each do |conversation_part|
      write_to_file("\n<-------- CONVERSATION PART #{current_count+=1} OF #{total_count} -------->\n")
      parse_conversation_part(conversation_part)
    end

    write_to_file("\n\n------------- ------------- CONVERSATION #{conversation.id} END ------------- -------------")
    write_bottom_separator
  end

  def parse_conversation_part(conversation_part)
    write_to_file("PART TYPE: #{conversation_part.part_type}")
    write_to_file("PART BODY:")
    write_to_file(parse_html_part(conversation_part.body))
  end

  def parse_html_part(html)
  	Nokogiri::HTML(html).text
  end

  def initialize_file
  	File.write(output_file_path, "")
  	puts "Writing output to #{Dir.pwd}/#{output_file_path}"
  end

  def write_to_file(content)
  	File.open(output_file_path, 'a+') do |f|
  		f.puts(content.to_s + "\n")
  	end
  end

  def write_header_to_file
  	write_top_separator
  	write_to_file("PANDA Intercom export archive script")
  	write_to_file("Started on: #{Time.now}")
  	write_to_file("By: Arnaud Lenglet (@arnlen)")
  	write_bottom_separator
  end

  def write_footer_to_file
  	write_top_separator
  	write_to_file("PANDA Intercom export completed")
  	write_to_file("Finished on: #{Time.now}")
  	write_bottom_separator
  end

  def write_top_separator
  	write_to_file("\n\n------------- ------------- ------------- -------------")
  end

  def write_bottom_separator
  	write_to_file("------------- ------------- ------------- ------------- ------------- -------------\n\n")
  end

end