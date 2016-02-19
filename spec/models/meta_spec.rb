require 'rails_helper'

RSpec.describe Meta, type: :model do
  let!(:meta) { FactoryGirl.create(:meta) }
  describe '.increment_games_played' do
    it 'adds 1 to games played' do
      meta.increment_games_played
      expect(meta.games_played).to eq 1
      meta.increment_games_played
      expect(meta.games_played).to eq 2
    end
  end

  describe '.increment_wins' do
    it 'adds 1 to games played' do
      meta.increment_wins
      expect(meta.wins).to eq 1
      meta.increment_wins
      expect(meta.wins).to eq 2
    end
  end

  describe '.increment_kills' do
    it 'adds 1 to games played' do
      meta.increment_kills
      expect(meta.kills).to eq 1
      meta.increment_kills
      expect(meta.kills).to eq 2
    end
  end

  describe '.add_to_xp' do
    it 'adds # to games played' do
      meta.add_to_xp(42)
      expect(meta.xp).to eq 42
      meta.add_to_xp(6)
      expect(meta.xp).to eq 48
    end
  end
end
