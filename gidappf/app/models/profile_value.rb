class ProfileValue < ApplicationRecord
  belongs_to :profile_key, optional: true
end
