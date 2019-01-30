class Vacancy < ApplicationRecord
  belongs_to :class_room_institute
  belongs_to :user
end
