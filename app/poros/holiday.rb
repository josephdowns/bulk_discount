class Holiday
  attr_reader :name, :date
  def initialize(hash)
    @name = hash[:name]
    @date = Date.parse(hash[:date])
  end
end
