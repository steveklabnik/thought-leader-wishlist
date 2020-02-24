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

**Some rolls are missing PvE or PvP sections. What gives?** If that's the case,
I'm of the opinion it's not worth chasing ツ
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
