require 'probability'
require 'roll'

TRAIT_PRETTY = [
  {:key => 'barrels',     :label => 'Barrels'},
  {:key => 'magazines',   :label => 'Mags   '},
  {:key => 'perks1',      :label => 'Perks 1'},
  {:key => 'perks2',      :label => 'Perks 2'},
  {:key => 'masterworks', :label => 'MWorks '},
]

class RollSet

  def initialize(activity_name, item_id, traits, roll_data)
    @activity_name = activity_name
    @item_id = item_id
    @traits = traits
    @name = roll_data['name']
    @overview = roll_data['overview']
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

  def generate_thoughts_txt
    StringIO.new.tap do |output|
      output.puts("#### **#{@name}**")
      
      output.puts(@overview)

      output.puts('```')
      TRAIT_PRETTY.each do |t|
        good_perks = @base_perks[t[:key]].length
        total_perks = @traits[t[:key]]['t']
        available_slots = @traits[t[:key]]['c']

        p = Probability.column_probability(good_perks, total_perks, available_slots)
        
        message = (p.to_i == 1) ? '*' : (@base_perks[t[:key]].join(', '))
        output.puts("  #{t[:label]} [%3d%%]: #{message}" % [p * 100])
      end
      output.puts('```')
      
      output.puts('| Variant | Chance |')
      output.puts('|:-|-:|')
      @rolls.each do |r|
        output.puts("| #{r.roll_name} | %0.1f%% |" % [r.probability()])
      end
    end.string
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

      fq_name = "(%s) %s %s" % [@activity_name, @name, roll_name]

      @rolls << Roll.new(@item_id, fq_name, roll_name, @traits, perks)
    end
  end

end