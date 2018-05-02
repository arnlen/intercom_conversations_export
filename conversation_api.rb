class ConversationApi
  attr_reader :intercom

  def initialize(intercom)
    @intercom = intercom
  end

  def get_single_conversation(conversation_id)
    puts "Finding conversation ##{conversation_id}"
    intercom.conversations.find(id: conversation_id)
  end

  def get_first_page_of_conversations
    # Get the first page of your conversations
    check_rate_limit do
      puts "Getting first page of conversations"
      conversations = intercom.get("/conversations", "")
    end
  end

  def get_next_page_of_conversations(next_page_url)
    check_rate_limit do
      puts "Getting next page of conversations"
      conversations = intercom.get(next_page_url, "")
    end
  end

  def get_all_conversations
    conversation_list = get_first_page_of_conversations
    conversations = conversation_list["conversations"]

    # Pagination
    current_page = conversation_list["pages"]["page"]
    total_pages = conversation_list["pages"]["total_pages"]
    puts "Total pages: #{total_pages}"
    puts "Collected conversations so far: #{conversations.count}"

    while current_page < total_pages
      conversation_list = get_next_page_of_conversations(conversation_list['pages']['next'])
      current_page = conversation_list["pages"]["page"]

      conversations += conversation_list["conversations"]
      puts "Collected conversations so far: #{conversations.count}"
      puts conversations.inspect
    end

    conversations
  end

  private

  def check_rate_limit
    current_rate = yield
    if intercom.rate_limit_details[:remaining] && intercom.rate_limit_details[:remaining] <= 30
      sleep 10
      puts "RATE LIMIT REACH: SLEEPING... zzZZzzZzzz..."
    end
    current_rate
  end

end