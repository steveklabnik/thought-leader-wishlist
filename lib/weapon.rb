class Weapon

  attr_reader :name
  attr_reader :item_hash
  attr_reader :dt_url
  attr_reader :lightgg_url

  def initialize(name, item_hash)
    @name = name
    @item_hash = item_hash
    @dt_url = "https://destinytracker.com/destiny-2/db/items/#{item_hash}"
    @lightgg_url = "https://www.light.gg/db/items/#{item_hash}/"
  end

end