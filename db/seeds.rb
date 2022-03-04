# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name: "admin1", email: "admin1@mail.com", password: "password", admin: true)

10.times do |n|
  name = Faker::Name.first_name
  email = Faker::Internet.email
  password = "password"
  user = User.create!(
    name: name,
    email: email,
    password: password,
    admin: false,
  )

  create_time = Faker::Time.between(from: DateTime.now, to: DateTime.now + 100)
  deadline_time = Faker::Time.between(from: create_time + 1, to: create_time + 365)

  Task.create!(
    name: "task#{n + 1}",
    explanation: "ex#{n + 1}",
    created_at: create_time,
    deadline: deadline_time,
    progress: "#{["未着手", "着手中", "完了"].sample}",
    priority: rand(0..2),
    user_id: user.id,
  )
end

label = ["赤", "青", "黄", "緑", "茶", "黒", "紫", "白", "灰", "朱"]
label.each do |i|
  Label.create!(name: i)
end
