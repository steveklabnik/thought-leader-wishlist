require 'date'
require 'yaml'

require_relative 'helpers'

TRAITS = [
  {:key => 'barrels',     :label => 'Barrels', :fallback => '(Any barrel)'},
  {:key => 'magazines',   :label => 'Mags   ', :fallback => '(Any magazine)'},
  {:key => 'perks1',      :label => 'Perks 1', :fallback => '(Any perk)'},
  {:key => 'perks2',      :label => 'Perks 2', :fallback => '(Any perk)'},
  {:key => 'masterworks', :label => 'MWorks ', :fallback => '(Any masterwork)'},
]

desc "Format notes from our roll data"
task :generate_thoughts, [:environment] do |t, args|

  File.open(thoughts_filename(args.environment), 'w') do |thoughts|
    thoughts.puts <<-PREAMBLE
# Welcome to the Sliflist!
This document is generated from a custom Destiny Item Manager "wishlist" and was
created on `#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S %:z")}`. The most recent
version of this document can always be found [here](https://github.com/rslifka/wishlist/).

**Why are some rolls missing PvE or PvP sections?**

Likely it means that there's no standout roll to be chasing there and/or there
are other better options for the slot. You see this most often for
Energy/Secondary weapons because that slot is in such high contention. Another
example would be swords: no sword roll has a PvP section.

**Why are the rolls in the order they are?**

Weapons are "matched" as soon as they are found in the list, from top to bottom.
Generally speaking I work to ensure rolls don't overlap, but sometimes they will
and I'll call those out (e.g. Last Perdition has/had a similar PvE and PvP roll).

**You're crazy and are missing rolls!**

By all means, let me know how my reasoning is off. We're all in pursuit of the same
objective!
PREAMBLE

    weapons = []

    thoughts.puts("\n---\n")
    Dir.children('wish_dsl').sort.each do |collection|
      thoughts.puts("\n**#{collection}**")
      Dir.children(File.join('wish_dsl', collection)).sort.each do |weapon|
        w = YAML.load_file(File.join('wish_dsl', collection, weapon))
        weapons << w
        group_links = w['groups'].map do |g|
          link = "#{w['name'].downcase} - #{g['name'].downcase}".gsub(/'/,'').gsub(/\//,'').gsub(/\W/,'-')
          "[#{g['name']}](##{link})"
        end
        thoughts.puts("* #{w['name']} (#{group_links.join(', ')})")
      end
    end
    thoughts.puts("\n---\n")

    weapons.each do |weapon|
      weapon['groups'].each do |group|

        thoughts.puts("## #{weapon['name']} - #{group['name']}")

        thoughts.puts("*For all possible perks, check out **#{weapon['name']}** over on [light.gg](#{weapon['lightgg']})*")
        thoughts.puts
        thoughts.puts

        thoughts.puts(group['summary'])

        group['rolls'].each do |r|
          thoughts.puts("* **%s (%0.1f%% chance)**: %s" % [r['name'], calculate_probability(weapon, r), r['desc'].strip])
          thoughts.puts('  ```')
          TRAITS.each do |t|
            p = column_probability(weapon, r, t[:key])
            message = (p.to_i == 1) ? '*' : (r[t[:key]].join(', '))
            thoughts.puts("  #{t[:label]} [%3d%%]: #{message}" % [p * 100])
          end
          thoughts.puts('  ```')
        end
      end
    end
  end
end
