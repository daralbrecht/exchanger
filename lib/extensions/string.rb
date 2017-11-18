# Add new methods for String class
class String
  def a_date?
    Date.parse(self)
    true
  rescue ArgumentError
    false
  end

  def a_number?
    to_f.to_s == self || to_i.to_s == self
  end
end
