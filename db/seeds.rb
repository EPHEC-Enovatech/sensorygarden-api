# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


Sensor.create([
    { sensorName: "Temperature", sensorUnit: "Celcius" },
    { sensorName: "Pression", sensorUnit: "Bar" },
    { sensorName: "Humidite", sensorUnit: "Pourcent" }
])

User.create([
    { nom: "Doe", prenom: "John", email: "john@doe.com", password: '1234', password_confirmation: '1234', confirm_email: true },
    { nom: "Doe", prenom: "Jane", email: "jane@doe.com", password: '1234', password_confirmation: '1234', confirm_email: false },
    { nom: "Password", prenom: "Reset test", email: "pass@reset.com", password: '1234', password_confirmation: "1234", confirm_email: true }
])

Device.create( device_id: 'ABC000111', user_id: 1, deviceName: "Potager de John")


DataRecord.create( device_id: 'ABC000111', timestamp: Date.new(2018, 10, 17), sensor_id: 1, data: 15 )

Category.create([
    { categoryName: "Category 1" },
    { categoryName: "Category 2" }
])

Post.create ([
    { postTitle: "Post 1", user_id: 1, postText: "Some text", postDate: DateTime.now },
    { postTitle: "Post 2", user_id: 1, postText: "Some text", postDate: DateTime.now },
    { postTitle: "Post 3", user_id: 1, postText: "Some text", postDate: DateTime.now }
])

CategoriesPost.create([
    {
        post_id: 1,
        category_id: 1
    },
    {
        post_id: 2,
        category_id: 2
    },
    {
        post_id: 3,
        category_id: 1
    },
    {
        post_id: 3,
        category_id: 2
    }
])
