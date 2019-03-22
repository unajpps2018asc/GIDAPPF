class SetsStudentsController < ApplicationController
  def change_commission
    # a = ProfileKey.where(key: 'Elección de turno hasta[Hr]:').where.not(profile: Profile.first)
    # a += ProfileKey.where(key: 'Elección de turno desde[Hr]:').where.not(profile: Profile.first)
    # a += ProfileKey.where(key: 'Se inscribe a cursar:').where.not(profile: Profile.first)
    # a.each do |e|
    #   k = e.key
    #   v=e.profile_values
    #   unless v.empty? || v.first.value.blank? then
    #     p "Perfil: #{e.profile.name} #{k} #{v.first.value}"
    @profiles_period = Profile.where.not(id: 1)
    #   end
    # end
    @comms_period = Commission.all
  end

  def selected_commission
  end
end
