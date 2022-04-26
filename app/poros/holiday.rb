class Holiday
  attr_reader :name, :date
  def initialize(hash)
    @name = hash[:name]
    @date = hash[:date]
  end
end
