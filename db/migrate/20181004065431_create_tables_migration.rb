class CreateTablesMigration < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :nom, null: false
      t.string :prenom, null: false
      t.string :mail, null: false
    end

    create_table :devices do |t|
      t.bigint :user_id
      t.string :deviceName, null: false, default: "Unnamed device"
    end

    add_foreign_key :devices, :users

    create_table :sensors do |t|
      t.string :sensorName, null: false
      t.string :sensorUnit, null: false
    end

    create_table :data do |t|
      t.bigint :device_id
      t.timestamp :timestamp, null: false
      t.bigint :sensor_id
      t.float :data, null: false
    end

    add_foreign_key :data, :devices
    add_foreign_key :data, :sensors
    
  end
end
