class Region

  attr_reader :id, :name

  def initialize(options)
  	@id = options['id']
  	@name = options['name']
  end

  def self.find(id)
  	all.find{|region| region.id.to_i==id.to_i}
  end

  def self.all
	@regions ||= HTTParty.get("#{configatron.registry.uri}/regions.json")['regions'].collect{|region|
	  new(region)
	}
  end

end
