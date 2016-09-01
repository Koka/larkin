# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: "John Smith", login: "dispatcher", password: "dispatcher")
User.create(name: "Mark Shopengauer", login: "driver1", password: "driver1")
User.create(name: "Ali Lichtensmidt", login: "driver2", password: "driver2")
