require 'date'
require 'yaml'

desc "Format notes from our roll data"
task :generate_thoughts do
  weapon_roll_groups = []
  Dir['wish_dsl/**/*.yml'].each do |roll_file|
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
      thoughts.puts # Required for the following table to render properly
      thoughts.puts("| Roll | Description |")
      thoughts.puts("| :--- | :---        |")
      g['rolls'].each do |r|
        perk_descriptions = []
        perk_descriptions << (r['barrels'].empty? ? '(Any barrel)' : '(' + r['barrels'].join(' `or` ') + ')')
        perk_descriptions << (r['magazines'].empty? ? '(Any magazine)' : '(' + r['magazines'].join(' `or` ') + ')')
        perk_descriptions << (r['perks1'].empty? ? '(Any perk)' : '(' + r['perks1'].join(' `or` ') + ')')
        perk_descriptions << (r['perks2'].empty? ? '(Any perk)' : '(' + r['perks2'].join(' `or` ') + ')')
        perk_descriptions << (r['masterworks'].empty? ? '(Any Masterwork)' : '(' + r['masterworks'].join(' `or` ') + ')')
        thoughts.puts("| **#{r['name']}** | #{perk_descriptions.join(' `and` ')} |")
      end
    end
  end
end