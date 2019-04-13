###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>               #
# Tutores:                                                                #
#    - UNAJ: Dr. Ing. Morales, Martín                                     #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                            #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                               #
#    - TAPTA: Dra. Ferrari, Mariela                                       #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
# Archivo GIDAPPF/gidappf/app/models/user.rb                              #
###########################################################################
# t.string "email", default: "", null: false
# t.string "encrypted_password", default: "", null: false
# t.string "reset_password_token"
# t.datetime "reset_password_sent_at"
# t.datetime "remember_created_at"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
###########################################################################
class User < ApplicationRecord

  #############################################################################
  # Configuracion del control de autenticacion Devise                         #
  #############################################################################
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  #############################################################################
  # Asociación uno a muchos: soporta que un usuario sea asignado muchas veces #
  #                          en la commision como el creador de la comision.  #
  #                          Si se borra, la comision nilifica al creador.    #
  #############################################################################
  has_many :commissions, dependent: :nullify

  ##########################account######################################
  # Asociación uno a muchos: soporta que un usuario sea asignada muchas #
  #                          veces en la relación usercommissionrole.   #
  #                          Si se borra, lo hace  usercommissionrole.  #
  #######################################################################
  has_many :usercommissionroles, dependent: :delete_all

  ##########################account######################################
  # Asociación uno a muchos: soporta que un usuario sea asignada muchas #
  #                          veces en la relación document.             #
  #                          Si se borra, el document nilifica user.    #
  #######################################################################
  has_many :documents, dependent: :nullify

  validate :minimun_security_requierements

  ##########################account######################################
  # Usado en la validacion.                                             #
  #######################################################################
  def minimun_security_requierements
    errors.add(:password,'Is a default, please use another password...') unless is_usable_password?
  end

  ####################################################################################
  # Prerequisitos:                                                                   #
  #     1) Modelo inicializado.                                                      #
  #     2) Usuario con email student@gidappf.edu.ar existente.                       #
  #     3) Clase LockEmail existente conteniendo el array LIST.                      #
  #     4) Perfil de usuario con email student@gidappf.edu.ar existente en LIST[1]). #
  #     5) Clave 3 del perfil de usuario student@gidappf.edu.ar existente.           #
  # Devolución: True si el password ingresado es aceptable.                          #
  ####################################################################################
  def is_usable_password?
    out = true
    unless LockEmail::LIST.include?(self.email) then
      dni = User.find_by(email: LockEmail::LIST[1]).documents.first.profile.profile_keys.find(3).key
      if self.documents.present? &&
        self.documents.first.profile.profile_keys.find_by(key: dni).profile_values.present? then
        if self.documents.first.profile.profile_keys.find_by(key: dni).
          profile_values.first.value.eql?(password) then
          out = false
        end
      end
    end
    out
  end

  ####################################################################################
  # Prerequisitos:                                                                   #
  #     1) Modelo inicializado.                                                      #
  # parámetros:                                                                      #
  #           time_sheet: hoja de tiempos del periodo                                #
  # Devolución: True si el usuario esta asignado al time_sheet.                      #
  ####################################################################################
  # def assigned_in_time_sheet?(time_sheet)
  #   out = false
  #   unless self.documents.empty? then
  #     # profile_key_hour_from = self.documents.first.profile.profile_keys.find_by(key: ProfileKey.find(24).key) #'Elección de turno desde[Hr]:'
  #     # unless profile_key_hour_from.profile_values.empty? then
  #       # if !profile_key_hour_from.profile_values.first.value.blank? &&# si es mayor o igual a 'Elección de turno desde[Hr]:'
  #         # profile_key_hour_from.profile_values.first.value.to_i*60 >= time_sheet.time_category.first &&
  #         # profile_key_hour_from.profile.profile_keys.find_by(key:ProfileKey.find(25).key). #'Elección de turno hasta[Hr]:'
  #         #   profile_values.first.value.to_i*60 <= time_sheet.time_category.last &&  # si es menor o igual a 'Elección de turno hasta[Hr]:'
  #         # !profile_key_hour_from.profile.profile_keys.find_by(key:ProfileKey.find(23).key).profile_values.empty? && #"Se inscribe a cursar:"
  #         # time_sheet.is_of_trayect?(
  #         #   profile_key_hour_from.profile.profile_keys.find_by(key:ProfileKey.find(23).key).profile_values.first.value) &&
  #         # profile_key_hour_from.profile.valid_to <= time_sheet.end_date &&
  #         # profile_key_hour_from.profile.valid_from >= time_sheet.start_date then # Si el perfil esta habilitado
  #         # out = self.usercommissionroles.where(commission: time_sheet.commission).count > 0
  #         if self.documents.first.profile.valid_to <= time_sheet.end_date &&
  #           self.documents.first.profile.valid_from >= time_sheet.start_date then # Si el perfil esta habilitado
  #           out = self.usercommissionroles.where(commission: time_sheet.commission).count > 0
  #       end # if profile_key_hour_from.key.eql?...
  #     end # unless profile_key_hour_from....
  #   # end # unless self.documents.empty?
  #   out
  # end # method

  # def assignable_in_time_sheet_hour?(time_category)
  #   out = false
  #   unless self.documents.empty? then
  #     profile_key_hour_from = self.documents.first.profile.profile_keys.find_by(key: ProfileKey.find(24).key) #'Elección de turno desde[Hr]:'
  #     unless profile_key_hour_from.profile_values.empty? then
  #       if profile_key_hour_from.profile_values.first.value.to_i*60 >= time_category.first &&
  #         profile_key_hour_from.profile.profile_keys.find_by(key:ProfileKey.find(25).key). #'Elección de turno hasta[Hr]:'
  #           profile_values.first.value.to_i*60 <= time_category.last then # si es menor o igual a 'Elección de turno hasta[Hr]:'
  #           out = true
  #       end # if profile_key_hour_from.key.eql?...
  #     end # unless profile_key_hour_from....
  #   end # unless self.documents.empty?
  #   out
  # end

end
