require 'v2_generator'

describe V2Generator do
  
  describe '#generate_toc_link' do
    let(:roll_data) { 
      { 
        'name' => 'Seventh Seraph SI-2',
        'activities' => [
          {
            'name' => 'PvP'
          },
          {
            'name' => 'PvE'
          }
        ]
      }
    }
    let(:toc_markdown) { "* Seventh Seraph SI-2 ([PvP](#seventh-seraph-si-2---pvp), [PvE](#seventh-seraph-si-2---pve))" }

    it 'generates table of contents links for all roll groups' do
      expect(subject.generate_toc_link(roll_data)).to eq(toc_markdown)
    end
  end

end