class DataRecord < ApplicationRecord
    validates :device_id, presence: true
    validates :timestamp, presence: true
    validates :data, presence: true
end