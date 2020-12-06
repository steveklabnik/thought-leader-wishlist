require 'yaml'

require 'probability'

PERK_MAP = YAML.load_file('perk_ids.yml')

class Roll

  attr_reader :name
  attr_reader :roll_name

  def initialize(item_id, fq_name, roll_name, traits, perks)
    @item_id = item_id
    @name = fq_name
    @roll_name = roll_name
    @traits = traits
    @perks = perks
  end

  def wishlist_txt
    StringIO.new.tap do |output|
      output.puts(wishlist_comment())
      wishlist_roll_data(output)
    end.string
  end

  def probability
    columnar_probabilities = []
    @perks.each do |perk_name, acceptable_perks|
      good_perks = acceptable_perks.length
      total_perks = @traits[perk_name]['t']
      available_slots = @traits[perk_name]['c']
      columnar_probabilities << Probability.column_probability(good_perks, total_perks, available_slots)
    end
    columnar_probabilities.reduce(:*) * 100
  end

  def to_s
    <<-ROLL
      Name: #{@name}
      Perks: #{@perks}
    ROLL
  end

  private 

  def wishlist_comment
    "//notes:%s / %0.1f%% chance" % [@name, probability()]
  end

  def wishlist_roll_data(output)
    perk_ids = []
    %w(barrels magazines perks1 perks2 masterworks).each do |slot|
      perk_ids << convert_to_perk_ids(@perks[slot]) unless @perks[slot].empty?
    end
    write_roll(output, perk_ids, [], 0)
  end

  def convert_to_perk_ids(perk_names)
    perk_names.each do |perk|
      raise "Perk Name #{perk} not found in perk_ids.yml" unless PERK_MAP[perk] 
    end
    perk_names.map{|n| PERK_MAP[n]}.flatten
  end
  
  def write_roll(output, perk_ids, roll, row)
    if (row == perk_ids.length-1)
      perk_ids[row].each do |p|
        output.puts("dimwishlist:item=#{@item_id}&perks=#{(roll+[p]).join(',')}")
      end
      return
    end
  
    perk_ids[row].each do |p|
      write_roll(output, perk_ids, roll + [p], row + 1)
    end
  end

end