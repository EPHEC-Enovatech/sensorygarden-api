class CreateTablesMigration < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :nom, null: false
      t.string :prenom, null: false
      t.string :mail, null: false
    end

    create_table :devices do |t|
      t.string :device_id, null: false, unique: true
      t.bigint :user_id, null: false
      t.string :deviceName, null: false, default: "Unnamed device"
    end

    add_index :devices, :device_id, unique: true
    add_foreign_key :devices, :users

    create_table :sensors do |t|
      t.string :sensorName, null: false
      t.string :sensorUnit, null: false
    end

    create_table :data_records do |t|
      t.string :device_id, null: false
      t.timestamp :timestamp, null: false
      t.bigint :sensor_id, null: false
      t.float :data, null: false
    end

    add_foreign_key :data_records, :devices, column: :device_id, primary_key: :device_id
    add_foreign_key :data_records, :sensors
    
  end
end
