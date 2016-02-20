class Description < ActiveRecord::Base
  belongs_to :box
  belongs_to :npc
  belongs_to :item

  def image
    return "box/#{self.file_path}.jpg" unless self.box.nil?
    return "npc/#{self.file_path}.jpg" unless self.npc.nil?
    return "item/#{self.file_path}.jpg" unless self.item.nil?
  end

  def self.pick_from_json(type)
    data_hash = Description.read_from_json(type)
    data_hash.to_a.sample.to_h
  end

  private

  def self.read_from_json(type)
    file = File.read(Rails.root.join("app/assets/json/#{type}_descriptions.json"))
    JSON.parse(file)
  end
end
