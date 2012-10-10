class Client
  attr_reader :first_name, :last_name, :email, :phone

  def first_name= name 
    @first_name = name
  end

  def last_name= name
    @last_name = name
  end

  def email= email
    @email = email
  end

  def phone= phone
    @phone = phone
  end

end