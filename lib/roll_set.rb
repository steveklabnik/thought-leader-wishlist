require 'roll'

class RollSet

  def initialize(activity_name, item_id, traits, roll_data)
    @activity_name = activity_name
    @item_id = item_id
    @traits = traits
    @name = roll_data['name']
    @base_perks = roll_data['perks']['base']
    @extended_perks = roll_data['perks']['extensions']
    @variants = roll_data['variants']

    @rolls = []
    create_rolls
  end

  def to_s
    output = StringIO.new
    @rolls.each do |r|
      output.puts(r)
    end
    output.string
  end

  def generate_wishlist_txt
    StringIO.new.tap do |output|
      @rolls.each do |r|
        output.puts(r.wishlist_txt())
      end
    end.string
  end

  private

# GOLD MASTER
# //notes:(PvP) Slif's "Full Auto Super Shredder" 💥Collector's Edition / 0.9% chance
# //notes:(PvP) "Full Auto Super Shredder" 💥(Minus Masterworks) / 1.8% chance
# //notes:(PvP) "Threat Level Super Shredder" 🧵 / 0.9% chance
# //notes:(PvP) "Threat Level" 🧵(Minus Masterworks) / 1.8% chance
# //notes:(PvP) "Basic Super Shredder" ⚙️ / 5.5% chance
# //notes:(PvP) "Basic Shredder" ⚙️ (Minus Masterworks) / 10.9% chance
# //notes:(PvE) "Sparks Flying" 🎇 / 2.8% chance
# //notes:(PvE) "Champion Slayer" 🏆 / 2.8% chance
# //notes:(PvE) "You're Trapped In Here With Me" 🏢 / 2.8% chance

  def create_rolls
    @variants.each do |roll_name|
      perks = Marshal.load(Marshal.dump(@base_perks))
    
      # additions = []
      # matches = roll_name.match(/\+(\w+)?/)
      # additions = matches.captures if matches
      # additions.each do |a|
      #   perks[a].merge(@extended_perks[a])
      # end

      removals = []
      matches = roll_name.match(/-(\w+)?/)
      removals = matches.captures if matches
      removals.each do |r|
        perks[r].clear
      end

      variant_name = "(%s) %s %s" % [@activity_name, @name, roll_name]

      @rolls << Roll.new(@item_id, variant_name, @traits, perks)
    end
  end

end