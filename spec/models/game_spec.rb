require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:grid) { FactoryGirl.create(:grid) }
  let!(:game) { FactoryGirl.create(:game, grid: grid) }

  describe '.write_note' do
    context 'with text' do
      it 'creates a note' do
        string = 'Lorem ipsum...'
        game.write_note(string)
        expect(Note.first.text).to eq string
      end
    end

    context 'without text' do
      it 'does not create a note' do
        string = ''
        game.write_note(string)
        expect(Note.count).to eq 0
      end
    end
  end

  describe '.recent_notes' do
    let!(:note_1) { FactoryGirl.create(:note, text: '1', game: game) }
    let!(:note_2) { FactoryGirl.create(:note, text: '2', game: game) }
    let!(:note_3) { FactoryGirl.create(:note, text: '3', game: game) }

    it 'returns the most recent notes associated with a game from newest to oldest' do
      expect(game.recent_notes).to eq [note_3, note_2, note_1]
    end
  end

  describe '.victory?' do
    let!(:grid) { FactoryGirl.create(:grid) }
    let!(:game) { FactoryGirl.create(:game, grid: grid) }

    context 'with a dead npc on the victory square' do
      before do
        grid.update(victory_box_id: grid.boxes.second.id)
        stat = FactoryGirl.create(:stat, current_health: 0)
        box_id = grid.boxes.second.id
        npc = FactoryGirl.create(:npc)
        npc.update(stat: stat, current_box_id: box_id)
      end
      it { expect(game.victory?).to eq true }
    end

    context 'with an alive npc on the victory square' do
      before do
        grid.update(victory_box_id: grid.boxes.second.id)
        stat = FactoryGirl.create(:stat, current_health: 10)
        box_id = grid.boxes.second.id
        npc = FactoryGirl.create(:npc)
        npc.update(stat: stat, current_box_id: box_id)
      end
      it { expect(game.victory?).to eq false }
    end

    context 'with an empty victory square' do
      before do
        grid.update(victory_box_id: grid.boxes.second.id)
        box_id = grid.boxes.second.id
      end
      it { expect{game.victory?}.to raise_error RuntimeError }
    end
  end

  describe '.defeat?' do
    let!(:player) { FactoryGirl.create(:player, game: game) }
    context 'with an alive player' do
      it { expect(game.defeat?).to eq false}
    end
    context 'with a dead player' do
      before do
        stat = FactoryGirl.create(:stat, current_health: 0)
        player.update(stat: stat)
      end
      it { expect(game.defeat?).to eq true }
    end
  end

  describe '.default_endings' do
    it { expect(game.grid.victory_description_id).not_to eq nil }
    it { expect(game.grid.defeat_description_id).not_to eq nil }
  end
end
