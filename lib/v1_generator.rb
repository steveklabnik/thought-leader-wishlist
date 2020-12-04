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

end
