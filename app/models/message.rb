class Message < ApplicationRecord
  belongs_to :profile
  belongs_to :room
end
