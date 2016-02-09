# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(
  email: 'wandersen02@gmail.com',
  password: '12345678'
)

game = Game.create

Player.create(name: 'socratesinblack', game: game)

grid = Grid.create(length: 3, width: 3, game: game)

[1,2,3].each do |n|
  [1,2,3].each do |i|
    Box.create(x: n, y: i, grid: grid)
  end
end
