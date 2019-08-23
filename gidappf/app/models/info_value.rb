class InfoValue < ApplicationRecord
  belongs_to :info_key, optional: true
  has_one_attached :active_stored

  def gidappf_readonly?
    self.info_key.info_values.count > 0 &&
    self.info_key.client_side_validator_id.present? &&
    self.info_key.client_side_validator.content_type.eql?('GIDAPPF read only')
  end

end
