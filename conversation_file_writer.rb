require 'time'

class ConversationFileWriter
	attr_accessor :output_file_path

	def initialize
		@output_file_path = "conversation_exports/debug.export"
	end

	def write_single_conversation_to_file(single_conversation, output_file_name)
	  write_top_separator
	  write_to_file("------------- ------------- CONVERSATION #{single_conversation[:id]} START ------------- -------------\n\n")
    write_to_file("CONVERSATION ID: #{single_conversation[:id]}")
    write_to_file("NUM PARTS: #{single_conversation[:parts].length}")

		single_conversation[:parts].each do |conversation_part|
			write_conversation_single_part(conversation_part)
		end

	  write_to_file("\n\n------------- ------------- CONVERSATION #{single_conversation[:id]} END ------------- -------------")
	  write_bottom_separator
	end

	def write_conversations_to_file(conversations, output_file_name, start_time = nil)
		initialize_file(output_file_name)
		write_header_to_file(start_time)

		total_conversations = conversations.size

		conversations.each_with_index do |single_conversation, index|
			write_to_file("Exporting conversation #{index + 1} of #{total_conversations}")
			write_single_conversation_to_file(single_conversation, output_file_name)
		end

		write_footer_to_file
	end

	def write_conversation_single_part(single_part)
		write_top_separator
	  write_to_file("PART TYPE: #{single_part[:type]}")

	  case single_part[:author][:type]
	  when "bot"
	  	write_to_file("PART AUTHOR: bot")
	  else
	  	write_to_file("PART AUTHOR: #{single_part[:author][:name]} (#{single_part[:author][:email]})")
	  end

	  write_to_file("PART BODY:\n")
	  write_to_file(single_part[:body])
	end

	private

	def initialize_file(output_file_name)
		@output_file_path = "conversation_exports/#{output_file_name}"

		File.write(output_file_path, "")
		puts "Writing output to #{Dir.pwd}/#{output_file_path}"
	end

	def write_to_file(content)
		File.open(output_file_path, 'a+') do |f|
			f.puts(content.to_s + "\n")
			puts content
		end
	end

	def write_header_to_file(start_time = nil)
		write_top_separator
		write_to_file("PANDA Intercom export archive script")
		write_to_file("Started at: #{start_time ? start_time : Time.now}")
		write_to_file("Finished at: #{Time.now}")
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