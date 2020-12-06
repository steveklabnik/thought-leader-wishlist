require 'roll_set'

class V2Generator

  def generate_toc_link(roll_data)
    activities = roll_data['activities']
    weapon_name = roll_data['name']
    
    activity_links = activities.map do |a|
      activity_name = a['name']
      link = "#{weapon_name.downcase} - #{activity_name.downcase}".gsub(/'/,'').gsub(/\//,'').gsub(/,/,'').gsub(/\./,'').gsub(/\W/,'-')
      "[#{activity_name}](##{link})"
    end
    "* #{weapon_name} (#{activity_links.join(', ')})"
  end

  def generate_roll(roll_data)
    ''
  end

  def generate_wishlist(roll_data)
    StringIO.new.tap do |output|
      roll_data['activities'].each do |a|
        a['roll_sets'].each do |rs_data|
          rs = RollSet.new(a['name'], roll_data['item_id'], roll_data['traits'], rs_data)
          output.puts(rs.generate_wishlist_txt())
        end
      end
    end.string
  end

end