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

These are my recommended rolls for weapons in Destiny 2. There is a focus on
weapons from the current season (starting with Season 9). As time permits,
I go back and fill in world drops.

* This document is generated from a custom Destiny Item Manager ["wishlist"](https://www.reddit.com/r/DestinyTheGame/comments/ab7lai/wish_lists_are_live_in_dim/).
* It was generated `#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S %:z")}`.
* The most recent version can always be found [here](https://github.com/rslifka/wishlist/).

---
PREAMBLE

    weapons = []

    TOC = YAML.load_file('toc.yml')
    TOC['ordering'].each do |collection|
      thoughts.puts("\n**#{TOC['naming'][collection]}**")
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
