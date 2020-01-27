require 'date'

desc "Concat everything under ./lists"
task :combine_wishlists do
  File.open('wishlist.txt', 'w') do |wishlist|
    wishlist.puts("// Wishlist generated around #{DateTime.now.strftime("%e %b %Y %H:%M:%S")}")
    wishlist.puts('// Up-to-date version: https://github.com/rslifka/wishlist')
    wishlist.puts('')
    Dir.glob('lists/*.txt') do |filename|
      wishlist.puts(File.read(filename))
      wishlist.puts('')
    end
  end
end

desc "Extract notes on thought process for all weapons"
task :thought_process do
  File.open('thought_process.md', 'w') do |thoughts|
    thoughts.puts <<-PREAMBLE
This file was auto-generated at `#{DateTime.now.strftime("%e %b %Y %H:%M:%S")}`. An up-to-date version can be found [here](https://github.com/rslifka/wishlist).

These rolls are applied in order for each weapon, so the ordering is important. This means the better rolls will match first, in much the same you would decide on a roll yourself. E.g. Steelfeather PvE rolls at the top of the list are `Feeding Frenzy + Swashbuckler + lots of other cool stuff` and the last on the list requires only `Feeding Frenzy + Swashbuckler` because if all else fails, those are the two perks you'll need; otherwise it's just cool-looking random kinetic Auto Rifle :)

This also means that, if your PvP and PvE rolls are similar (they usually aren't) that there's a chance a match is flagged and commented as a PvP roll in the DIM "Notes" section, when it could do double-duty. That's just how the wishlist feature currently works, so use your own discretion.
PREAMBLE
    wishlist = File.read('wishlist.txt')
    item_name = ''
    lightgg_link = ''
    section_opening = false
    wishlist.each_line do |line|
      line.match(/\/\/item:(.*),lightgg:(.*)/) do |m|
        item_name = m[1]
        lightgg_link = m[2]
        section_opening = true
        thoughts.puts "## #{item_name}"
        next
      end
      line.match(/\/\/notes:(.*)/) do |m|
        # Sub in links
        markdown = m[1].gsub(
          /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,})/,
          '[\1](\1)'
        )
        if section_opening
          thoughts.puts("#{markdown} ([view item on light.gg](#{lightgg_link}))")
          thoughts.puts # Required for the table to render properly
          thoughts.puts("| Roll | Description |")
          thoughts.puts("| :--- | :---        |")
        else
          m[1].match(/.*"(.*)"\] (.*)/) do |roll_description|
            name = roll_description[1]
            description = roll_description[2]
            thoughts.puts("| **#{name}** | #{description} |")
          end
        end
        section_opening = false
      end
    end
  end
end

task :default => ["combine_wishlists", "thought_process"]