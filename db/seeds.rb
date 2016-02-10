# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create(
  email: 'wandersen02@gmail.com',
  password: '12345678'
)

grid = Grid.create(length: 3, width: 3)

descriptions = [
  'Here two roads diverge in a narrow wood.',
  'It is dark, you are likely to be eaten by a Grue.',
  'You are at the gate of an ancient castle.',
  'You are in a forgotten throne room of a kingdom time forgot. ',
  'You are in a wind swept desert.',
  'You are on the edge of a treacherous cliff.',
  'You are deep in the bowels of the dungeon.',
  'You are alone in the great hall. You hear whispers from the feast of a thousand pointless victories.',
  'There are lights coming from all around you, yet it feels like a crypt.',
  'In the distance you can see the spiers of a mighty fortress.',
  'You\'re lost. But then again, when have you ever been found?'
]

image_urls = [
 'https://static.pexels.com/photos/4855/black-and-white-architecture-shops-brussels-medium.jpg',
 'https://static.pexels.com/photos/19035/pexels-photo-medium.jpg',
 'https://static.pexels.com/photos/279/black-and-white-branches-tree-high-medium.jpg',
 'https://static.pexels.com/photos/524/black-and-white-tiles-clean-corridor-medium.jpg'
]

[1,2,3].each do |n|
  [1,2,3].each do |i|
    description = Description.create(text: descriptions.sample, url: image_urls.sample)
    Box.create(x: n, y: i, grid: grid, description: description)
  end
end

descriptions = [
  'A brute instrument of destruction, it\'s hard to tell where the rage stops and the muscle begins.',
  'A cheeky bunny. Fluffy, cute, deadly.',
  'Slime, scales, the stench of treachery, and death.'
]

image_urls = [
  'https://static.pexels.com/photos/1469/black-and-white-animals-sheep-flock-medium.jpg',
  'https://static.pexels.com/photos/21802/pexels-photo-medium.jpg',
  'https://static.pexels.com/photos/5672/dog-cute-adorable-play-medium.jpg'
]

['Omar the Bold', 'Hergon the Terrible', 'Grif the Vain'].each do |n|
  d = Description.create(name: n, text: descriptions.sample, url: image_urls.sample)
  h = rand(1..10)
  stat = Stat.create(base_health: h, base_attack: rand(1..10), base_defense: rand(1..10), current_health: h)
  Npc.create(description: d, grid: grid, stat: stat)
end

description = Description.create(
  name: "Mjolnir",
  text: 'The hammer of Thor!',
  url: 'https://static.pexels.com/photos/8263/pexels-photo-medium.jpg'
)
stat = Stat.create(base_attack: 10)
Item.create(description: description, stat: stat, grid: grid)

description = Description.create(
  name: "Captian America's Sheild",
  text: 'Unbreakable!',
  url: 'https://static.pexels.com/photos/21300/pexels-photo-medium.jpg'
)
stat = Stat.create(base_defense: 10)
Item.create(description: description, stat: stat, grid: grid)

description = Description.create(
  name: 'Pick of Destiny',
  text: 'Eternal life, but at what price?',
  url: 'https://static.pexels.com/photos/8663/drill-bits-medium.jpg'
)
stat = Stat.create(base_health: 10, base_defense: -10)
i = Item.create(description: description, stat: stat, equipped: true, grid: grid)

Npc.first.update(items: [i])
