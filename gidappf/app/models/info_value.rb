class InfoValue < ApplicationRecord
  belongs_to :info_key

  def gidappf_readonly?
    self.info_key.profile_values.count > 0 &&
    self.info_key.client_side_validator_id.present? &&
    self.info_key.client_side_validator.content_type.eql?('GIDAPPF read only')
  end

end
