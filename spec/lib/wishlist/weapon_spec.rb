require 'weapon'

describe Weapon do

  subject(:breachlight) {
    Weapon.new('Breachlight', 1289997971)
  }

  it 'has a name' do
    expect(breachlight.name).to eq('Breachlight')
  end

  it 'has an itemHash' do
    expect(breachlight.item_hash).to eq(1289997971)
  end

  it 'has a Destiny Tracker URL' do
    expect(breachlight.dt_url).to eq('https://destinytracker.com/destiny-2/db/items/1289997971')
  end

  it 'has a light.gg URL' do
    expect(breachlight.lightgg_url).to eq('https://www.light.gg/db/items/1289997971/')
  end

end