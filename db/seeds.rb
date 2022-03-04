# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "admin",
  email: "admin@mail.com"
  password: "password",
  admin: true,
)


1.times do |n|
  name = Faker::Name.first_name
  email = Faker::Internet.email
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    admin: true,
  )
end

5.times do |i|
  Label.create!(name: "label#{i + 1}")
end