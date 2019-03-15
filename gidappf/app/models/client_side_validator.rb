class ClientSideValidator < ApplicationRecord
  has_many :profile_keys, dependent: :nullify
end
