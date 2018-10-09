class Device < ApplicationRecord
    has_many :data_records
    has_many :sensors, through: :data_records

    validates :deviceName, presence: true
end