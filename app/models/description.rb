class Description < ActiveRecord::Base
  belongs_to :box
  belongs_to :npc
  belongs_to :item

  def self.pick_from_json(type)
    data_hash = Description.read_from_json(type)
    data_hash.to_a.sample.to_h
  end

  def self.read_from_json(type)
    file = File.read(Rails.root.join("app/assets/json/#{type}_descriptions.json"))
    JSON.parse(file)
  end
end
