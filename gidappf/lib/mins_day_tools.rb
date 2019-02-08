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
# Archivo GIDAPPF/gidappf/lib/mins_day_tools.rb                           #
###########################################################################
module MinsDayTools

  ###################################################################################
  # Prerequisitos:                                                                  #
  #           1) to_hour:to_min mayor que from_hour:from_min                        #
  # parámetros:                                                                     #
  #           to_hour - hora hasta.                                                 #
  #           to_min -  minutos de la hora hasta.                                   #
  #           from_hour - hora desde.                                               #
  #           from_min -  minutos de la hora desde.                                 #
  # Devolución: Entero reprecentando los minutos entre desde y hasta.               #
  ###################################################################################
  def mins_duration(to_hour, to_min, from_hour, from_min)
    y=2000
    m=12
    d=31
    z="+00:00"
    (((
      Time.new(y, m, d, to_hour, to_min, 0, z) -
      Time.new(y, m, d, from_hour, from_min, 0, z)
    ).round)/1.minute).round
  end #method

  ###################################################################################
  # Prerequisitos:                                                                  #
  #           1) ninguno                                                            #
  # parámetros:                                                                     #
  #           mins - es un arreglo de enteros o de nils seguidos.                   #
  # Devolución: Arreglo anidando arreglos de minuto desde y minuto hasta. Cada sub- #
  #             arreglo es un intervalo de tiempo en minutos correspondiendo a los  #
  #             indices de los intervalos nil de mins                               #
  ###################################################################################
  def nil_mins_to_intervals(mins)
    unless mins.nil? then
      i=0
      fmin=nil
      tmin=nil
      out=Array.new
      mins.each do |m|
        if m.nil? && fmin.nil? then
          fmin=i
        elsif !m.nil? && !fmin.nil? then
          out << [fmin,i]
          fmin=nil
        end
        i+=1
      end
      unless fmin.nil? then out << [fmin,mins.count] end
    end
    out
  end #method

  #################################################################################
  # Prerequisitos:                                                                #
  #           1) ninguno                                                          #
  # parámetros:                                                                   #
  #           to_min_day -  minutos de hasta.                                     #
  #           from_min_day -  minutos de desde.                                   #
  # Devolución: Arreglo completo con -1 en los indices menores que from_min_day y #
  #             mayores a to_min_day.                                             #
  #################################################################################
  def set_nil_mins(from_min_day,to_min_day)
    unless from_min_day < 0 || to_min_day < 0 || from_min_day > to_min_day then
      arr=Array.new
      k=0
      while k<1440 do
        if from_min_day <= k && k < to_min_day then
          arr << nil
        else
          arr << -1
        end
        k+=1
      end
    end
    arr
  end #method

  ###############################################################################
  # Prerequisitos:                                                              #
  #           1) ninguno                                                        #
  # parámetros:                                                                 #
  #           arr -  vector de indice de minutos nil o -1                       #
  #           i -  minutos de desde.                                            #
  #           j -  minutos de hasta.                                            #
  #           id -  usuario del minuto                                          #
  # Devolución: Arreglo completo con id en indices menores que j y mayores a i. #
  ###############################################################################
  def set_occupied_mins(arr,i,j,id)
    unless arr.empty? || i < 0 || i > arr.count|| j < 0 || j > arr.count || id<0 then
      while i<j do
        arr[i]=id
        i+=1
      end
    end
    arr
  end #method

  #############################################################
  # Prerequisitos:                                            #
  #           1) last_mins mayor que first_mins               #
  # parámetros:                                               #
  #           last_mins -  minutos de hasta.                  #
  #           first_mins -  minutos de desde.                 #
  # Devolución: Intervalo legible en un string.               #
  #############################################################
  def mins_to_hours_interval_str(last_mins, first_mins)
    unless last_mins.nil? || last_mins < 0 || first_mins.nil? || first_mins < 0 || first_mins > last_mins then
      out = ''
      y=2000
      m=12
      d=31
      z="+00:00"
      out += Time.new(y, m, d, (first_mins/60).round, first_mins%60, 0, z).strftime('%R')
      out += '~'
      out += Time.new(y, m, d, (last_mins/60).round, last_mins%60, 0, z).strftime('%R ')
    end
    out
  end#mins_to_hours_interval_str

end #module
