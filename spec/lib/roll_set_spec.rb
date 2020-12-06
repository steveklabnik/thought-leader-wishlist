require 'roll_set'

describe RollSet do
  let(:traits) {
    {
      'barrels'      => {'t' => 9, 'c' => 2},
      'magazines'    => {'t' => 8, 'c' => 2},
      'perks1'       => {'t' => 6, 'c' => 1},
      'perks2'       => {'t' => 6, 'c' => 1},
      'masterworks'  => {'t' => 4, 'c' => 1}
    }
  }
  let(:roll_data) {
    {
      'name' => 'Full Auto Super Shredder',
      'perks' => {
        'base' => {
          'barrels' => ['Polygonal Rifling', 'Chambered Compensator', 'Smallbore', 'Corkscrew Rifling', 'Hammer-Forged Rifling'],
          'magazines' => ['Accurized Rounds', 'Steady Rounds', 'Flared Magwell', 'Tactical Mag'],
          'perks1' => ['Full Auto Trigger System'],
          'perks2' => ['Vorpal'],
          'masterworks' => ['Stability MW', 'Range MW']
        },
        'extensions' => { 

        }
      },
      'variants' => [
        '💥💥💥🌟',
        '💥💥💥 (-masterworks)'
      ]
    }
  }

  subject(:si2) {
    RollSet.new('PvP', 3937866388, traits, roll_data)
  }

  describe 'wishlist formatting' do
    it 'outputs comments in the correct format with correct probabilities' do
      gold_output = IO.read('./spec/gold_data/roll_set_data.txt')
      expect(subject.generate_wishlist_txt()).to eq(gold_output)
    end
  end

end