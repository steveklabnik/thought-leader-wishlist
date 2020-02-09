require 'date'
require 'yaml'

WEAPON_DATABASE = YAML.load_file('weapon_database.yml')

TRAITS = [
  {:key => 'barrels',     :label => 'Barrels', :fallback => '(Any barrel)'},
  {:key => 'magazines',   :label => 'Mags   ', :fallback => '(Any magazine)'},
  {:key => 'perks1',      :label => 'Perks 1', :fallback => '(Any perk)'},
  {:key => 'perks2',      :label => 'Perks 2', :fallback => '(Any perk)'},
  {:key => 'masterworks', :label => 'MWorks ', :fallback => '(Any masterwork)'},
]

desc "Format notes from our roll data"
task :generate_thoughts do
  weapon_roll_groups = []
  Dir['wish_dsl/**/*.yml'].sort.each do |roll_file|
    weapon_roll_groups += YAML.load_file(roll_file)
  end

  File.open('thought_process.md', 'w') do |thoughts|
    thoughts.puts <<-PREAMBLE
This file was auto-generated at `#{DateTime.now.strftime("%e %b %Y %H:%M:%S")}`. An up-to-date version can be found [here](https://github.com/rslifka/wishlist).

These rolls are applied in order for each weapon, so the ordering is important. This means the better rolls will match first, in much the same you would decide on a roll yourself. E.g. Steelfeather PvE rolls at the top of the list are `Feeding Frenzy + Swashbuckler + lots of other cool stuff` and the last on the list requires only `Feeding Frenzy + Swashbuckler` because if all else fails, those are the two perks you'll need; otherwise it's just cool-looking random kinetic Auto Rifle :)

This also means that, if your PvP and PvE rolls are similar (they usually aren't) that there's a chance a match is flagged and commented as a PvP roll in the DIM "Notes" section, when it could do double-duty. That's just how the wishlist feature currently works, so use your own discretion.
PREAMBLE
    weapon_roll_groups.each do |g|
      thoughts.puts("## #{g['name']}")
      thoughts.puts(g['summary'])

      g['rolls'].each do |r|
        thoughts.puts("* **%s (%0.1f%% chance)**: %s" % [ r['name'], calculate_probability(g['item_id'], r), r['desc'].strip])
        thoughts.puts('  ```')
        TRAITS.each do |t|
          if (r[t[:key]].empty?)
            thoughts.puts("  #{t[:label]} (100%): #{t[:fallback]}")
          else
            p = column_probability(g['item_id'], r, t[:key])
            thoughts.puts("  #{t[:label]} ( %d%%): #{r[t[:key]].join(', ')}" % [p * 100])
          end
        end
        thoughts.puts('  ```')
      end
    end
  end
end

def factorial(n)
  return 1 if n == 0
  (1..n).inject(:*)
end

def combinations(total_perks, unique_choices)
  return factorial(total_perks).to_f / (factorial(unique_choices) * factorial(total_perks-unique_choices))
end

def column_probability(item_id, roll, column_key)
  raise "Weapon w/ID '#{item_id}' not found in weapon_database.yml" unless WEAPON_DATABASE[item_id]
  good_perks = roll[column_key].length
  # An empty list of perks means all are acceptable
  return 1.0 if good_perks == 0

  total_perks = WEAPON_DATABASE[item_id][column_key]['t']
  available_slots = WEAPON_DATABASE[item_id][column_key]['c']  
  
  # If we're gauranteed to get a perk because there are more slots
  # than there are bad perks, bail out
  return 1.0 if (available_slots + good_perks > total_perks)
    
  total = combinations(total_perks, available_slots)
  bad   = combinations(total_perks - good_perks, available_slots)
  (total - bad) / total
end

def calculate_probability(item_id, roll)
  raise "Weapon w/ID '#{item_id}' not found in weapon_database.yml" unless WEAPON_DATABASE[item_id]
  columnar_probabilities = []
  TRAITS.each do |t|
    columnar_probabilities << column_probability(item_id, roll, t[:key])
  end
  columnar_probabilities.reduce(:*) * 100
end
