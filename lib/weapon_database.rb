require 'yaml'

class WeaponDatabase

  @@WEAPON_DATABASE = YAML.load_file('weapon_database.yml')

  def self.contains?(item_id)
    @@WEAPON_DATABASE.each do |c|
      return true if c['weapons'].keys.include?(item_id)
    end
    false
  end

  def self.total_perks_in_column(item_id, column_key)
    w = find_weapon(item_id)
    w[column_key]['t']
  end

  def self.slots_in_column(item_id, column_key)
    w = find_weapon(item_id)
    w[column_key]['c']
  end

  private

  def self.find_weapon(item_id)
    raise "Weapon w/ID '#{item_id}' not found in weapon_database.yml" unless contains?(item_id)
    @@WEAPON_DATABASE.each do |c|
      return c['weapons'][item_id] if c['weapons'].keys.include?(item_id)
    end
  end

end