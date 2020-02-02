require 'date'
require 'yaml'

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
    TRAITS = [
      {:key => 'barrels',     :label => 'Barrels :', :fallback => '(Any barrel)'},
      {:key => 'magazines',   :label => 'Mags    :', :fallback => '(Any magazine)'},
      {:key => 'perks1',      :label => 'Perks 1 :', :fallback => '(Any perk)'},
      {:key => 'perks2',      :label => 'Perks 2 :', :fallback => '(Any perk)'},
      {:key => 'masterworks', :label => 'MWorks  :', :fallback => '(Any masterwork)'},
    ]
    weapon_roll_groups.each do |g|
      thoughts.puts("## #{g['name']}")
      thoughts.puts(g['summary'])

      g['rolls'].each do |r|
        thoughts.puts("* **#{r['name']}**: #{r['desc'].strip}")
        thoughts.puts('  ```')
        TRAITS.each do |t|
          thoughts.puts("  #{t[:label]} #{(r[t[:key]].empty? ? t[:fallback] : r[t[:key]].join(', '))}")
        end
        thoughts.puts('  ```')
      end
    end
  end
end