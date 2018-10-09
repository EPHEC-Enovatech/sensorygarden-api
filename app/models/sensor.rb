class Sensor < ApplicationRecord
    has_many :data_records
    has_many :devices, through: :data_records

    validates :sensorName, presence: true
    validates :sensorUnit, presence: true
end