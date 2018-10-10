class Device < ApplicationRecord
    has_many :data_records, dependent: :destroy
    has_many :sensors, through: :data_records

    validates :deviceName, presence: true
end