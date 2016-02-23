module Character
  extend ActiveSupport::Concern

  MAX_ITEMS = 5
  MAX_EQUIPPED = 2

  def equipped_items
    items_in_inventory.where(equipped: true)
  end

  def box
    Box.find(current_box_id)
  end

end
