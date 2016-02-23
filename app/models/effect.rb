class Effect < ActiveRecord::Base
  has_one :description, dependent: :destroy
  has_one :stat, dependent: :destroy

  belongs_to :grid

  CLASSES = %w(heal hurt teleport)

  def of_type(effect_type)
    case effect_type
    when 'heal'
      stat = Stat.create(character_class: effect_type, current_health: 10)
      description = Description.create(name: 'Healing Well')
      update(stat: stat, description: description)
    when 'hurt'
      stat = Stat.create(character_class: effect_type, base_attack: rand(1..5), current_health: 1)
      description = Description.create(name: 'Trap')
      update(stat: stat, description: description)
    when 'teleport'
      stat = Stat.create(character_class: effect_type, current_health: 1)
      description = Description.create(name: 'Teleport')
      update(stat: stat, description: description)
    else
      # ...
    end
  end

  def fire(player)
    case stat.character_class
    when 'heal'
      heal(player)
    when 'hurt'
      hurt(player)
    when 'teleport'
      teleport(player)
    else
      # ...
    end
  end

  def type?(effect_type)
    stat.character_class == effect_type
  end

  private

  def heal(player)
    return unless type?('heal')
    healable = player.stat.base_health - player.stat.current_health
    healed = [stat.current_health, healable].min
    player.stat.update(current_health: player.stat.current_health + healed)
    stat.update(current_health: stat.current_health - healed)
    player.game.write_note("Healing Well: You are healed #{healed} points.")
  end

  def hurt(player)
    return unless type?('hurt')
    damage = [player.stat.current_health, stat.base_attack].min
    player.stat.update(current_health: player.stat.current_health - damage)
    stat.update(current_health: stat.current_health - 1)
    player.game.write_note("Trap: Does #{damage} damage.")
  end

  def teleport(player)
    return unless type?('teleport')
    box = player.game.grid.random_clear_box
    stat.update(current_health: stat.current_health - 1)
    player.update(current_box_id: box.id)
    player.game.write_note("You pass through a teleport.")
  end
end
