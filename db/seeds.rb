# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(name: "John Smith", login: "dispatcher", password: "dispatcher")

d1 = User.find_by(login: 'driver1')
d1 ||= User.create(name: "Mark Shopengauer", login: "driver1", password: "driver1")

d2 = User.find_by(login: 'driver2')
d2 ||= User.create(name: "Ali Lichtensmidt", login: "driver2", password: "driver2")

Truck.create(name: "Truck 1", max_weight: 10000, max_volume: 1400, driver_id: d1.id)
Truck.create(name: "Truck 2", max_weight: 10000, max_volume: 1400, driver_id: d2.id)
