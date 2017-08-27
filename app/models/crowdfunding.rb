class Crowdfunding < ActiveRecord::Base
  # attr_accessor :id, :title, :perex, :price, :unit, :description, :image_url, :vs_prefix

  def human_price
    "#{price} Kč / #{unit}"
  end

  # def self.all
  #   @all ||= load_from_google
  # end
  #
  # def self.find(id)
  #   all.detect{|i| i.id==id.to_i}
  # end

  private
  def self.load_from_google
    data = HTTParty.get('https://spreadsheets.google.com/feeds/list/12iqXog6LLXJq8LbKVlK4pcJq8--CtvLAtlvr_uktPs0/3/public/values?alt=json')
    items = data["feed"]["entry"].each_with_index.map  {|entry,i|
      item = self.new
      item.id=i+1
      item.vs_prefix=entry['gsx$vsprefix']['$t']
      item.title=entry['gsx$nazev']['$t']
      item.perex=entry['gsx$perex']['$t']
      item.price=entry['gsx$cena']['$t']
      item.unit=entry['gsx$jednotka']['$t']
      item.image_url=entry['gsx$obrazek']['$t']
      item.description=[entry['gsx$popis']['$t'],entry['gsx$popis2']['$t']].join("\n")
      item
    }
    items.each{|i| find_or_create_by(vs_prefix: i.vs_prefix).update_attributes i.attributes}
  end
end
