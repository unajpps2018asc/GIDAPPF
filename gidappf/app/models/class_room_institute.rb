require 'mins_day_tools'
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
# Archivo GIDAPPF/gidappf/app/models/class_room_institute.rb              #
###########################################################################
class ClassRoomInstitute < ApplicationRecord
  include MinsDayTools
  #####################################################################
  # Asociación uno a muchos: soporta que un Aula sea asignada muchas  #
  #                          veces en la relación vacancy             #
  #####################################################################
  has_many :vacancies, dependent: :delete_all

  ##################################################################
  # Prerequisitos:                                                 #
  #           1) Modelo de datos inicializado.                     #
  # parámetros:                                                    #
  #           ninguno.                                             #
  # Devolución: texto con el identificador y el porcentage libre.  #
  ##################################################################
  def to_list
    occ=Array.new
    7.times do |day_order|
      a1= holes_time(day_order)
      unless a1.nil? then occ += a1 end
    end
    mins=0
    unless occ.nil?
      occ.each do |e| mins += (e.last - e.first) end
    end
    case self.available_time
      when 812 #'Disponible de 8 a 12 hs.'
        percent = 100 -(100*mins)/(240*7)
      when 12 #"Disponible de 0 a 12 hs."
        percent = 100 -(100*mins)/(12*60*7)
      when 24 #"Disponible las 24 hs."
        percent = 100 -(100*mins)/(1440*7)
      when 1022 #"Disponible de 10 a 22 hs."
        percent = 100 -(100*mins)/(12*60*7)
      when 1624 #"Disponible de 16 a 24 hs."
        percent = 100 -(100*mins)/(8*60*7)
      else #"Sin frase en la opción: #{x}."
    end
    self.name+" - ("+percent.to_s+"%)"
  end

  ########################################################################
  # Prerequisitos:                                                       #
  #           1) Modelo de datos inicializado.                           #
  # parámetros:                                                          #
  #           day_order - 0 a 6 segun el dia de la semana.               #
  # Devolución: texto con la lista de intervalos ocupados.               #
  ########################################################################
  def free_time(day_order)
    out = ''
    arr=holes_time(day_order)
    unless arr.nil?
      arr.each do |e|
        out += mins_to_hours_interval_str(e.last,e.first)
      end
    else
      out=' - '
    end
    out
  end

  #######################################################################
  # Usado en hole_from_to                                               #
  #######################################################################
  def days_week_available
    week=Array.new
    week << self.available_monday
    week << self.available_tuesday
    week << self.available_wednesday
    week << self.available_thursday
    week << self.available_friday
    week << self.available_saturday
    week << self.available_sunday
    week
  end

  private

  ########################################################################
  # Prerequisitos:                                                       #
  #           1) Modelo de datos inicializado.                           #
  # parámetros:                                                          #
  #           day_order - 0 a 6 segun el dia de la semana.               #
  # Devolución: Arreglo con intervalos de tiempo usados por los horarios #
  #             asignados.                                               #
  ########################################################################
    def holes_time(day_order)
      hole=Array.new
      case self.available_time
        when 812 #'Disponible de 8 a 12 hs.'
          hole=nil_mins_to_intervals(hole_from_to(8*60,12*60,day_order))
        when 12 #"Disponible de 0 a 12 hs."
          hole=nil_mins_to_intervals(hole_from_to(0,12*60,day_order))
        when 24 #"Disponible las 24 hs."
          hole=nil_mins_to_intervals(hole_from_to(0,24*60,day_order))
        when 1022 #"Disponible de 10 a 22 hs."
          hole=nil_mins_to_intervals(hole_from_to(10*60,22*60,day_order))
        when 1624 #"Disponible de 16 a 24 hs."
          hole=nil_mins_to_intervals(hole_from_to(16*60,24*60,day_order))
        else #"Sin frase en la opción: #{x}."
        end
      hole
    end

    ##############################################################################
    # Prerequisitos:                                                             #
    #           1) Modelo de datos inicializado.                                 #
    # parámetros:                                                                #
    #           class_room_institute - instancia del aula.                       #
    #           from_min_day - primer minuto del dia disponible del aula.        #
    #           to_min_day - ultimo minuto del dia disponible del aula.          #
    #           day_order - indice del dia segun la semana.                      #
    # Devolución: Arreglo con nils indexados segun los minutos libres diarios    #
    #             disponibles del aula.                                          #
    ##############################################################################
    def hole_from_to(from_min_day, to_min_day,day_order)
      hole=Array.new
      time_sheet_hours=TimeSheetHour.where(vacancy: Vacancy.find_by(class_room_institute: self))
      time_sheet_hours -= time_sheet_hours.where(from_hour: 0, from_min: 0, to_hour: 0, to_min: 0)
      if days_week_available[day_order] then
        hole = set_nil_mins(from_min_day,to_min_day)
        time_sheet_hours.each do |time_sheet_hour|
          if time_sheet_hour.hour_week[day_order] then
            hole = set_occupied_mins(
              hole,
              mins_duration(time_sheet_hour.from_hour, time_sheet_hour.from_min,0,0),
              mins_duration(time_sheet_hour.to_hour, time_sheet_hour.to_min,0,0),time_sheet_hour.id
            )
          end
        end
      else
        hole=nil
      end
      hole
    end#hole_from_to

end
