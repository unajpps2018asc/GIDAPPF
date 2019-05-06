class ClientSideValidator < ApplicationRecord
  has_many :profile_keys, dependent: :nullify
  validates :content_type, presence: true, uniqueness: true
end
