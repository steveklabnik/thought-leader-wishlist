require 'stringio'

require 'date'
require 'yaml'

require 'helpers'

TRAITS = [
  {:key => 'barrels',     :label => 'Barrels'},
  {:key => 'magazines',   :label => 'Mags   '},
  {:key => 'perks1',      :label => 'Perks 1'},
  {:key => 'perks2',      :label => 'Perks 2'},
  {:key => 'masterworks', :label => 'MWorks '},
]

PERK_MAP = YAML.load_file('perk_ids.yml')

class V1Generator
  
  def generate_toc_link(roll_data)
    group_links = roll_data['groups'].map do |g|
      link = "#{roll_data['name'].downcase} - #{g['name'].downcase}".gsub(/'/,'').gsub(/\//,'').gsub(/,/,'').gsub(/\./,'').gsub(/\W/,'-')
      "[#{g['name']}](##{link})"
    end
    "* #{roll_data['name']} (#{group_links.join(', ')})"
  end

  def generate_roll(roll_data)
    thoughts = StringIO.new

    roll_data['groups'].each do |group|
      thoughts.puts("## #{roll_data['name']} - #{group['name']}")
      thoughts.puts("*For all possible perks, check out **#{roll_data['name']}** over on [light.gg](#{roll_data['lightgg']})*")
      thoughts.puts
      thoughts.puts
      thoughts.puts(group['summary'])
      group['rolls'].each do |r|
        description = r['desc'].strip
        headline = if (description == '...')
          thoughts.puts("* **%s - %0.1f%% chance**" % [r['name'], calculate_probability(roll_data, r)])
        else
          thoughts.puts("* **%s - %0.1f%% chance**: %s" % [r['name'], calculate_probability(roll_data, r), description])
        end
        thoughts.puts(headline)
        thoughts.puts('  ```')
        TRAITS.each do |t|
          p = column_probability(roll_data, r, t[:key])
          message = (p.to_i == 1) ? '*' : (r[t[:key]].join(', '))
          thoughts.puts("  #{t[:label]} [%3d%%]: #{message}" % [p * 100])
        end
        thoughts.puts('  ```')
      end
    end

    thoughts.string
  end

  def generate_wishlist(roll_data)
    wishlist = StringIO.new
    
    roll_data['groups'].each do |group|
      group['rolls'].each do |roll|
        wishlist.puts("//notes:%s / %0.1f%% chance" % [roll['name'], calculate_probability(roll_data, roll)])
        perk_ids = []
        %w(barrels magazines perks1 perks2 masterworks).each do |slot|
          perk_ids << convert_to_perk_ids(roll[slot]) unless roll[slot].empty?
        end
        write_roll(wishlist, roll_data['item_id'], perk_ids, [], 0)
      end
    end
    
    wishlist.string
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

end
