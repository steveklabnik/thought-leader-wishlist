require 'v1_generator'
require 'v2_generator'

class MarkdownGenerator

  GENERATORS = {
    '1' => V1Generator.new,
    '2' => V2Generator.new
  }

  def self.generate_toc_link(yml_file)
    roll_data = YAML.load_file(yml_file)
    get_generator(roll_data).generate_toc_link(roll_data)
  end

  def self.generate_roll(yml_file)
    roll_data = YAML.load_file(yml_file)
    get_generator(roll_data).generate_roll(roll_data)
  end

  def self.get_generator(roll_data)
    version = roll_data.has_key?('syntax_version') ? roll_data['syntax_version'] : '1'
    GENERATORS[version]
  end

end