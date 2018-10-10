class DataRecord < ApplicationRecord
    belongs_to :devices
    belongs_to :sensors

    validates :device_id, presence: true, uniqueness: true
    validates :sensors, presence: true
    validates :timestamp, presence: true
    validates :data, presence: true
end