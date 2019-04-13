class TimeSheet < ApplicationRecord
  belongs_to :commission

  #########################################################################
  # Asociación uno a muchos: soporta que un periodo sea asignada muchas   #
  #                          veces en la relación time_sheet_hour.        #                                                       #
  #                          Si se borra, lo hacen los  time_sheet_hour.  #
  #########################################################################
  has_many :time_sheet_hours, dependent: :delete_all
  validate :check_date_interval

  #####################################################################
  # Prerequisitos:                                                    #
  #           1) Modelo de datos inicializado.                        #
  # parámetros:                                                       #
  #           ninguno.                                                #
  # Devolución: texto con el identificador de la comision asociada al #
  #             periodo.                                              #
  #####################################################################
  def to_list
    self.commission.name
  end

  ########################################################################
  # Prerequisitos:                                                       #
  #           1) Modelo de datos inicializado.                           #
  # parámetros:                                                          #
  #           ninguno.                                                   #
  # Devolución: Array con dos elementos, el primero es el minimo horario #
  #          TimeSheetHour de los asignados. El segundo es el maximo     #
  #          horario de los asignados.                                   #
  ########################################################################
  def time_category
    out=[]
    unless self.time_sheet_hours.empty?
      min=60*24
      max=0
      self.time_sheet_hours.each do |h|
        if h.from_min.to_i+h.from_hour.to_i*60 < min then min=h.from_min.to_i+h.from_hour.to_i*60 end
        if h.to_min.to_i+h.to_hour.to_i*60 > max then max=h.to_min.to_i+h.to_hour.to_i*60 end
      end
      out << min
      out << max
    end
    out
  end

  ############################################################################
  # Prerequisitos:                                                           #
  #           1) Modelo de datos inicializado.                               #
  # parámetros:                                                              #
  #           trayect. (Primero, Segundo, Tercero, etc.)                     #
  # Devolución: True si las materias asignadas a los TimeSheetHour asignados #
  #           al presente TimeSheet tienen un trayect igual a trayect.       #
  # (provisoriamente comprueba a trayect del primer anotado)                 #
  ############################################################################
  def is_of_trayect?(trayect)
    u=Usercommissionrole.find_by(commission: self.commission)
    if !u.nil? && u.user.documents.first.profile.valid_to <= self.end_date &&
      u.user.documents.first.profile.valid_from >= self.start_date then
        u.user.documents.first.profile.profile_keys.
          find_by(key:ProfileKey.find(23).key).
            profile_values.first.value.upcase.eql?(trayect.upcase)
    else
      true
    end
  end

  ################################################################################
  # Prerequisitos:                                                               #
  # 1) Modelo inicializado.                                                      #
  # 2) Usuario con email student@gidappf.edu.ar existente.                       #
  # 3) Clase LockEmail existente conteniendo el array LIST.                      #
  # 4) Perfil de usuario con email student@gidappf.edu.ar existente en LIST[1]). #
  # parámetros:                                                                  #
  #           ninnguno                                                           #
  # Devolución: Mensaje con la fraccion de vacantes utilizadas en este periodo   #
  #             de la comision en un mensaje junto con la referencia.            #
  ################################################################################
  def commission_info
    "#{self.commission.name}: #{self.users_assigned_in_timesheet}/#{self.time_sheet_hours.first.vacancy.class_room_institute.vacancies.count}"
  end

  ################################################################################
  # Prerequisitos:                                                               #
  # 1) Modelo inicializado.                                                      #
  # 2) Usuario con email student@gidappf.edu.ar existente.                       #
  # 3) Clase LockEmail existente conteniendo el array LIST.                      #
  # 4) Perfil de usuario con email student@gidappf.edu.ar existente en LIST[1]). #
  # parámetros:                                                                  #
  #           ninguno                                                            #
  # Devolución: Número de asignados al TimeSheet seleccionado entre start_date y #
  #             end_date.                                                        #
  ################################################################################
  def users_assigned_in_timesheet
    out=0
    User.where.not(email: LockEmail::LIST).joins(documents: :profile, usercommissionroles: :role).
      select(:id, :profile_id, :role_id, :commission_id).each do |e|
        if e.role_id == 2 && Commission.find(e.commission_id).eql?(self.commission) &&
          Profile.find(e.profile_id).valid_from >= self.start_date &&
          Profile.find(e.profile_id).valid_to <= self.end_date then
          out += 1
        end
      end
    out
    end

  def selectable?
    self.end_date < Date.today || !self.enabled
  end

  private

  #######################################################################
  # Usado en la validacion.                                             #
  #######################################################################
  def check_date_interval
    errors.add(:end_date, 'must be a valid datetime') unless Date.parse(end_date.to_s) > Date.parse(start_date.to_s)
  end

end
