class TimeSheetHour < ApplicationRecord
  belongs_to :time_sheet
  validates :from_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24}
  validates :to_hour, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 24}
  validates :from_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60}
  validates :to_min, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 60}
  validates :to_hour, numericality: { greater_than_or_equal_to: :from_hour}

end
