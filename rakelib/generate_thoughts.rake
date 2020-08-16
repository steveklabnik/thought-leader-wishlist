require 'date'
require 'yaml'

require_relative 'helpers'

TRAITS = [
  {:key => 'barrels',     :label => 'Barrels'},
  {:key => 'magazines',   :label => 'Mags   '},
  {:key => 'perks1',      :label => 'Perks 1'},
  {:key => 'perks2',      :label => 'Perks 2'},
  {:key => 'masterworks', :label => 'MWorks '},
]

TOC = YAML.load_file('toc.yml')

PREAMBLE = <<-PRE
# **Welcome to the Sliflist!**

To use this wishlist in DIM, copy and paste this URL in the Settings
page under "Wish List"

```
https://raw.githubusercontent.com/rslifka/wishlist/master/wishlist.txt
```

Check out the [README](https://github.com/rslifka/wishlist/) for more info.

---
PRE

desc "Generate human-readable thoughts from our roll data"
task :generate_thoughts, [:environment] do |t, args|

  File.open(thoughts_filename(args.environment), 'w') do |thoughts|
    thoughts.puts PREAMBLE

    weapons = []

    TOC['ordering'].each do |collection|
      thoughts.puts("\n**#{TOC['naming'][collection]}**")
      Dir.children(File.join('wish_dsl', collection)).sort.each do |weapon|
        w = YAML.load_file(File.join('wish_dsl', collection, weapon))
        weapons << w
        group_links = w['groups'].map do |g|
          link = "#{w['name'].downcase} - #{g['name'].downcase}".gsub(/'/,'').gsub(/\//,'').gsub(/,/,'').gsub(/\./,'').gsub(/\W/,'-')
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
          description = r['desc'].strip
          headline = if (description == '...')
            thoughts.puts("* **%s (%0.1f%% chance)**" % [r['name'], calculate_probability(weapon, r)])
          else
            thoughts.puts("* **%s (%0.1f%% chance)**: %s" % [r['name'], calculate_probability(weapon, r), description])
          end
          thoughts.puts(headline)
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
