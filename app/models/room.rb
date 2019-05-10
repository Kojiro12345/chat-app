class Room < ApplicationRecord
  has_many :room_members, dependent: :destroy
  has_many :messages

  accepts_nested_attributes_for :room_members
end
