class ConversationApi
  attr_reader :intercom

  def initialize(intercom)
    @intercom = intercom
  end

  def get_single_conversation(conversation_id)
    intercom.conversations.find(id: conversation_id)
  end

  def get_first_page_of_conversations
    # Get the first page of your conversations
    check_rate_limit do
      conversations = intercom.get("/conversations", "")
    end
  end

  def get_next_page_of_conversations(next_page_url)
    check_rate_limit do
      conversations = intercom.get(next_page_url, "")
    end
  end

  private

  def check_rate_limit
    current_rate = yield
    puts "RATE LIMIT: #{intercom.rate_limit_details[:remaining]}"
    if intercom.rate_limit_details[:remaining] && intercom.rate_limit_details[:remaining] <= 30
      sleep 10
      puts "SLEEPING... zzZZzzZzzz..."
    end
    current_rate
  end

end