require 'date'
require 'yaml'

TRAITS = [
  {:key => 'barrels',     :label => 'Barrels', :fallback => '(Any barrel)'},
  {:key => 'magazines',   :label => 'Mags   ', :fallback => '(Any magazine)'},
  {:key => 'perks1',      :label => 'Perks 1', :fallback => '(Any perk)'},
  {:key => 'perks2',      :label => 'Perks 2', :fallback => '(Any perk)'},
  {:key => 'masterworks', :label => 'MWorks ', :fallback => '(Any masterwork)'},
]

desc "Format notes from our roll data"
task :generate_thoughts do

  File.open('thought_process.md', 'w') do |thoughts|
    thoughts.puts <<-PREAMBLE
# Welcome to the Sliflist!
This document is generated from a custom Destiny Item Manager "wishlist" and was
created on `#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S %:z")}`. The most recent
version of this document can always be found [here](https://github.com/rslifka/wishlist/).

These rolls are applied in order for each weapon, so the ordering is important.
This means the better rolls will match first, in much the same you would decide
on a roll yourself. For example Steelfeather PvE rolls at the top of the list are
`Feeding Frenzy + Swashbuckler + lots of other cool stuff` and the last on the
list requires only `Feeding Frenzy + Swashbuckler` because if all else fails,
those are the two perks you'll need; otherwise it's just cool-looking random
kinetic Auto Rifle.

This also means that, if your PvP and PvE rolls are similar (they usually aren't)
that there's a chance a match is flagged and commented as a PvP roll in the DIM
"Wishlist Notes" section (searchable in DIM via `wishlistnotes:`), when it could
do double-duty. That's just how the wishlist feature currently works, so use your
own discretion.
PREAMBLE

    weapons = []

    thoughts.puts("\n---\n")
    Dir.children('wish_dsl').sort.each do |collection|
      thoughts.puts("\n**#{collection}**")
      Dir.children(File.join('wish_dsl', collection)).sort.each do |weapon|
        w = YAML.load_file(File.join('wish_dsl', collection, weapon))
        weapons << w
        group_links = w['groups'].map{|x| "[#{x['name']}](##{URI.escape(w['name'].downcase + ' - ' + x['name'].downcase)})"}
        thoughts.puts("* #{w['name']} (#{group_links.join(', ')})")
      end
    end
    thoughts.puts("\n---\n")

    weapons.each do |weapon|

      weapon['groups'].each do |group|
        thoughts.puts("## #{weapon['name']} - #{group['name']}")
        thoughts.puts(group['summary'])

        group['rolls'].each do |r|
          thoughts.puts("* **%s (%0.1f%% chance)**: %s" % [r['name'], calculate_probability(weapon, r), r['desc'].strip])
          thoughts.puts('  ```')
          TRAITS.each do |t|
            if (r[t[:key]].empty?)
              thoughts.puts("  #{t[:label]} (100%): #{t[:fallback]}")
            else
              p = column_probability(weapon, r, t[:key])
              thoughts.puts("  #{t[:label]} ( %d%%): #{r[t[:key]].join(', ')}" % [p * 100])
            end
          end
          thoughts.puts('  ```')
        end
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

def column_probability(weapon, roll, column_key)
  good_perks = roll[column_key].length
  # An empty list of perks means all are acceptable
  return 1.0 if good_perks == 0

  total_perks = weapon['slots'][column_key]['t']
  available_slots = weapon['slots'][column_key]['c']
  
  # If we're gauranteed to get a perk because there are more slots
  # than there are bad perks, bail out
  return 1.0 if (available_slots + good_perks > total_perks)
    
  total = combinations(total_perks, available_slots)
  bad   = combinations(total_perks - good_perks, available_slots)
  (total - bad) / total
end

def calculate_probability(weapon, roll)
  columnar_probabilities = []
  TRAITS.each do |t|
    columnar_probabilities << column_probability(weapon, roll, t[:key])
  end
  columnar_probabilities.reduce(:*) * 100
end
