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

User.create({ nom: "Doe", prenom: "John", mail: "john@doe.com"})

Device.create( device_id: 'ABC000111', user_id: 1, deviceName: "Potager de John")


DataRecord.create( device_id: 'ABC000111', timestamp: DateTime.now, sensor_id: 1, data: 15 )