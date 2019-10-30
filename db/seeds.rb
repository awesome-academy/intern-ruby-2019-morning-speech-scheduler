User.create!(
  name: "DoanPhu",
  email: "doanphua4@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true)

User.create!(
  name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  admin: true)

50.times do |n|
  name = FFaker::Name.name
  email = "phu-#{n+1}@gmail.com"
  password = "123456"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
