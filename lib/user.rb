class User
  attr_reader :id
  attr_accessor :name

  def initialize(attributes)
    @id, @name = attributes.values_at(:id, :name)
  end
end
