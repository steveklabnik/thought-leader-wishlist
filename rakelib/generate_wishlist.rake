require 'date'
require 'set'
require 'yaml'

PERK_MAP = YAML.load_file('perk_ids.yml')

task :generate_wishlist do
  weapon_roll_groups = []
  Dir['wish_dsl/**/*.yml'].each do |roll_file|
    weapon_roll_groups += YAML.load_file(roll_file)
  end
  
  File.open('wishlist.txt', 'w') do |wishlist|
    wishlist.puts("title: SlifSF's Sliflist")
    wishlist.puts("description: https://github.com/rslifka/wishlist; generated: #{DateTime.now.strftime("%Y-%m-%d %H:%M:%S %:z")}")

    # We'll generate our "Trash" list from here, once all the registered rolls
    # are written to the wishlist
    item_ids = Set.new

    weapon_roll_groups.each do |g|
      item_ids.add(g['item_id'])
      g['rolls'].each do |r|
        wishlist.puts("//notes:#{r['name']}")
        perk_ids = []
        %w(barrels magazines perks1 perks2 masterworks).each do |slot|
          perk_ids << convert_to_perk_ids(r[slot]) unless r[slot].empty?
        end
        write_roll(wishlist, g['item_id'], perk_ids, [], 0)
      end
    end

    wishlist.puts('//notes:This roll did not match any roll in our wishlist. It could still be an amazing roll for you!')
    item_ids.each do |item_id|
      wishlist.puts("dimwishlist:item=-#{item_id}")
    end
  end
end

def convert_to_perk_ids(perk_names)
  perk_names.each do |perk|
    raise "Perk Name #{perk} not found in perk_ids.yml" unless PERK_MAP[perk] 
  end
  perk_names.map{|n| PERK_MAP[n]}.flatten
end

def write_roll(wishlist, item_id, perk_ids, roll, row)
  if (row == perk_ids.length-1)
    perk_ids[row].each do |p|
      wishlist.puts("dimwishlist:item=#{item_id}&perks=#{(roll+[p]).join(',')}")
    end
    return
  end

  perk_ids[row].each do |p|
    write_roll(wishlist, item_id, perk_ids, roll + [p], row + 1)
  end
end
