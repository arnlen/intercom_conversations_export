class UserApi
  attr_reader :intercom

  def initialize(intercom)
    @intercom = intercom
  end

  def get_user_by_id(id)
    puts "Finding user ##{id}"
    intercom.users.find(id: id)
  end

  def get_admin_by_id(id)
    puts "Finding admin ##{id}"
    intercom.admins.find(id: id)
  end

end