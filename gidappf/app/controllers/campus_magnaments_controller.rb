#############################################################################
# Universidad Nacional Arturo Jauretche                                     #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática            #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018    #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>                 #
# Tutores:                                                                  #
#    - UNAJ: Dr. Ing. Morales, Martín                                       #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                              #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                                 #
#    - TAPTA: Dra. Ferrari, Mariela                                         #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                       #
# Archivo GIDAPPF/gidappf/app/controllers/campus_magnaments_controller.rb   #
#############################################################################
class CampusMagnamentsController < ApplicationController

  ###################################################################################
  # Prerequisitos:                                                                  #
  #           1) Modelo de datos inicializado, segun 2, 3, 4 y 5.                   #
  #           2) ProfileKey numero 23 con valor key reprecentando trayecto.         #
  #           3) ProfileKey numero 24 con valor key reprecentando turno desde.      #
  #           4) ProfileKey numero 25 con valor key reprecentando turno hasta.      #
  #           5) Profile numero 1 es una plantilla, no tiene valores, solo claves.  #
  # Devolución: Accion que permite seleccionar periodos disponibles de comisiones y #
  #        mostrarlos en forma agrupada con los perfiles que podrian ser asignadoss #
  #        o ya estan asignados a estas comisiones. La vista proporciona el link a  #
  #        la modificacion de la seleccion causada por el usuario.                  #
  ###################################################################################
  def get_campus_segmentation
    @opt_periods = array_options_period
    @per_time_categ_profiles = []
    array_all_trayect.each do |trayect| #itera primero, segundo, tercero, etc.
      all_time_categories.each do |time_categ| #itera por cada turno
        profiles_in_time_category = [table_metadata_maker(time_categ, trayect,params[:profile_type])]# El subtitulo (*)
        ProfileKey.where(key: ProfileKey.find(24).key).where.not("profile_id < ?", LockEmail::LIST.count-1).each do |e| #'Elección de turno desde[Hr]:'
          unless e.profile_values.empty? || e.profile_values.first.value.blank? then
            if include_in_trayect_and_time_category_by_role?(e, trayect, time_categ, params[:profile_type]) then
              profiles_in_time_category << e.profile # si "Se inscribe a cursar:" es igual a trayect
            end #if e.key.eql?...
          end #unless e.profile_values...
        end #ProfileKey.where(key:...)...each do |e|
        unless profiles_in_time_category.count == 1 then # Devuelve en el array
          @per_time_categ_profiles << profiles_in_time_category # si contiene mas que solo  (*)el subtitulo
        end #unless profiles_in...
      end #all_time... do |time_categ|
    end #array_all_trayect.each do |trayect|
  end #action

  ####################################################################################
  # Prerequisitos:                                                                   #
  #           1) Modelo de datos inicializado, segun 2.                              #
  #           2) Role con campos enabled: true, level: 20.0 existente.               #
  #           3) Parámetro id del Profile válido.                                    #
  #           4) parametro box_selected válido.                                      #
  #           5) parametro def_period válido.                                        #
  # Devolución: Accion que permite seleccionar cambiar comisiones de cada perfil     #
  #        con los valores nuevos que se obtienen por parámetros. Luego redirecciona #
  #        a get_campus_segmentation con el cambio realizado y mostrando un mensaje. #
  ####################################################################################
  def set_campus_segmentation
    p = Profile.find(params[:id].to_i)
    ucrs = Profile.find(params[:id].to_i).documents.first.user.usercommissionroles
    authorize ucrs
    ucr = Usercommissionrole.find(params[:ucr_id].to_i)
    ts = TimeSheet.find(params[:box_selected].to_i)
    unless invalid_selection_to_set_ucr?(p,ucrs,ucr,ts) then
      set_usercommissionroles(ucr, ts.commission)
      redirect_to campus_magnaments_get_campus_segmentation_path(
        def_period: params[:def_period],
        profile_type: params[:profile_type]),
        notice: "Profile #{p.name} change to #{ts.commission.name}"
    else
      flash[:errors] = "Profile #{p.name}, schedule previously assigned for this #{params[:profile_type].first(params[:profile_type].index("@")).capitalize}…"
      redirect_to campus_magnaments_get_campus_segmentation_path(
        def_period: params[:def_period],
        profile_type: params[:profile_type])
    end
  end

  private

  ######################################################################
  # Metodo privado para definir el grupo de segmentacion.              #
  # Devuelve: true si profile_key_24 pertenece a trayect y time_categ  #
  #            sino false.                                             #
  ######################################################################
  def include_in_trayect_and_time_category_by_role?(profile_key_24, trayect, time_categ, profile_type)
    out = false
    if LockEmail::LIST[4].eql?(profile_type) then
      out = profile_key_24.profile_values.first.value.to_i*60 <= time_categ[0]*60+time_categ[1] && # si es mayor o igual a 'Elección de turno desde[Hr]:'
      !profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(25).key).nil? && #"Elección de turno hasta existente"
      profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(25).key). #'Elección de turno hasta[Hr]:'
        profile_values.first.value.to_i*60 >= time_categ[2]*60+time_categ[3] &&  # si es menor o igual a 'Elección de turno hasta[Hr]:'
      !profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(23).key).nil? && #"Se inscribe a cursar existente"
      !profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(23).key).profile_values.empty? && #"Se inscribe a cursar:"
      selected_period_profile(profile_key_24.profile) &&
      profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(23).key).profile_values.first.value.upcase.eql?(trayect.upcase)
    elsif LockEmail::LIST[3].eql?(profile_type) then
      out = profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(23).key).nil? && #"Se inscribe a cursar inexistente"
      profile_key_24.profile_values.first.value.to_i*60 <= time_categ[0]*60+time_categ[1] && # si es mayor o igual a 'Elección de turno desde[Hr]:'
      !profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(25).key).nil? && #"Elección de turno hasta existente"
      profile_key_24.profile.profile_keys.find_by(key:ProfileKey.find(25).key). #'Elección de turno hasta[Hr]:'
        profile_values.first.value.to_i*60 >= time_categ[2]*60+time_categ[3] &&  # si es menor o igual a 'Elección de turno hasta[Hr]:'
      Matter.find(profile_key_24.profile.profile_keys.find_by(key: ProfileKey.find(48).key).profile_values.first.value.to_i).trayect.upcase.eql?(trayect.upcase) &&
      selected_period_profile(profile_key_24.profile)
    end
    out
  end

  ###################################################################
  # Metodo privado para obtener la lista de periodos disponibles    #
  # Devuelve: un array con elementos string reprecentando periodos. #
  ###################################################################
  def array_options_period
    opt_periods = []
    TimeSheet.all.each do |cp|
      opt_periods << "#{cp.start_date.strftime('%d/%m/%Y')} ~ #{cp.end_date.strftime('%d/%m/%Y')}"
    end
    opt_periods
  end

  ####################################################################
  # Metodo privado para obtener la lista de trayectos disponibles    #
  # Devuelve: un array con elementos string reprecentando trayectos. #
  ####################################################################
  def array_all_trayect
    Matter.where(enable: true).pluck(:trayect).uniq
  end

  ######################################################################
  # Metodo privado para obtener la lista de turnos de las comisiones.  #
  # Devuelve: un array con tuplas de 4 numeros reprecentando turnos:   #
  #            hora desde, minutos desde, hora hasta, minutos hasta.   #
  ######################################################################
  def all_time_categories
    out=[]
    a=[]
    TimeSheet.where.not(id: TimeSheet.first.id).find_each do |c|
      a << c.time_category
    end
    a.uniq.each do |f|
      unless f.empty? then out << [f.first/60, f.first%60, f.last/60, f.last%60] end
    end
    out
  end

  #########################################################################
  # Metodo privado para obtener un subtitulo de la tabla correspondiente. #
  # Devuelve: un array con un string reprecentando a la tabla.            #
  #########################################################################
  def table_metadata_maker(time_categ, trayect, profile_type)
    out=[]
    if profile_type.eql?(LockEmail::LIST[4]) then
      out.push("Group by #{trayect} "+Time.new(2000,1,1,time_categ[0].to_i,time_categ[1].to_i).strftime('%R') +
        +' ~ '+Time.new(2000,1,1,time_categ[2].to_i,time_categ[3].to_i).strftime('%R'),
        time_sheet_from_commissions_in_period(time_categ, trayect))
    elsif profile_type.eql?(LockEmail::LIST[3]) then
      out.push("Group by #{trayect} "+Time.new(2000,1,1,time_categ[0].to_i,time_categ[1].to_i).strftime('%R') +
        +' ~ '+Time.new(2000,1,1,time_categ[2].to_i,time_categ[3].to_i).strftime('%R'),
        time_sheet_hour_from_commissions_in_period(time_categ, trayect))
    end
    out
  end

  ####################################################################################
  # Metodo privado para establecer si un perfil está dentro del período seleccionado #
  # Devuelve: true si el perfíl está dentro del período.                             #
  ####################################################################################
    def selected_period_profile(profile)
      profile.valid_from >= start_period && profile.valid_to <= end_period
    end

  ########################################################################################################
  # Metodo privado para decodificar el comienzo del periodo seleccionado por el parametro url def_period #
  # Devuelve: un objeto DateTime con la fecha del comienzo del periodo.                                  #
  ########################################################################################################
    def start_period
      out = nil
      if params[:def_period].nil? then out=Commission.last.start_date
      else
        strfetch = params[:def_period].split('~')[0]
        out = DateTime.new(strfetch.split('/')[2].to_i,strfetch.split('/')[1].to_i,
                strfetch.split('/')[0].to_i).in_time_zone(ENV['TZ'])
      end
      out
    end

  #####################################################################################################
  # Metodo privado para decodificar el final del periodo seleccionado por el parametro url def_period #
  # Devuelve: un objeto DateTime con la fecha del fin del periodo.                                    #
  #####################################################################################################
    def end_period
      out = nil
      if params[:def_period].nil? then out=Commission.last.end_date
      else
        strfetch = params[:def_period].split('~')[1]
        out = DateTime.new(strfetch.split('/')[2].to_i,strfetch.split('/')[1].to_i,
                strfetch.split('/')[0].to_i).in_time_zone(ENV['TZ'])
      end
      out
    end

  ######################################################################################################
  # Metodo privado para obtener la lista de periodos de comisiones que se solapan con el seleccionado. #
  # Devuelve: una query con todos los TimeSheet dentro del periodo seleccionado.                       #
  ######################################################################################################
    def time_sheet_from_commissions_in_period(schedul, trayect)
      out = []
      TimeSheet.where.not(commission: Commission.first).
        where(:start_date => start_period - 30.day  .. start_period + 30.day).
          where(:end_date => end_period - 30.day  .. end_period + 30.day).each do |time_sheet|
            if !time_sheet.time_category.empty? && time_sheet.is_of_trayect?(trayect) &&
              time_sheet.time_category.first >= schedul[1] + schedul[0]*60 &&
              time_sheet.time_category.last <= schedul[3] + schedul[2]*60 then
              out << time_sheet
            end
          end
      out
    end

  ####################################################################################################
  # Metodo privado para obtener la lista de horarios de periodos de comisiones que se solapan con el #
  # seleccionado.                                                                                    #
  # Devuelve: una query con todos los TimeSheet dentro del periodo seleccionado.                     #
  ####################################################################################################
    def time_sheet_hour_from_commissions_in_period(schedul, trayect)
      out = []
      TimeSheet.where.not(commission: Commission.first).
        where(:start_date => start_period - 30.day  .. start_period + 30.day).
          where(:end_date => end_period - 30.day  .. end_period + 30.day).each do |time_sheet|
            if !time_sheet.time_category.empty? && time_sheet.is_of_trayect?(trayect) &&
              time_sheet.time_category.first >= schedul[1] + schedul[0]*60 &&
              time_sheet.time_category.last <= schedul[3] + schedul[2]*60 then
                time_sheet.time_sheet_hours.select(:from_hour,:from_min,:to_hour,:to_min).distinct.each do |e|
                  out << TimeSheetHour.where(time_sheet: time_sheet, from_hour: e.from_hour, from_min: e.from_min, to_hour: e.to_hour,to_min: e.to_min).first
                end
            end
          end
      out
    end

  #####################################################################################
  # Metodo privado para obtener el rol equivalente en base al parámetro profile_type. #
  # Devuelve: alguno de los LockEmail::list que apuntan al perfil.                    #
  #####################################################################################
    def role_from_profile_type(old_role)
      out=''
      unless params[:profile_type].nil? then
        if params[:profile_type].eql?(LockEmail::LIST[4]) then
          out=Role.find_by(enabled: old_role.enabled, level: 20.0)
        elsif params[:profile_type].eql?(LockEmail::LIST[3]) then
          out=Role.find_by(enabled: old_role.enabled, level: 29.0)
        end
      end
      out
    end

  ########################################################################################
  # Metodo privado para obtener la actualizacion del rol y la asignacion de la comision. #
  # Si la comisión es la misma que estaba, entonces asigna la comision de ingresantes.   #
  ########################################################################################
    def set_usercommissionroles(usercommissionrole,commission)
      unless commission.eql?(usercommissionrole.commission)
        usercommissionrole.update(role: role_from_profile_type(usercommissionrole.role), commission: commission)
      else
        usercommissionrole.update(commission: Commission.first)
      end
    end

  ########################################################################################
  # Metodo privado para validacion de set_usercommissionroles.                           #
  ########################################################################################
    def invalid_selection_to_set_ucr?(profile,usercommissionroles,to_usercommissionrole,time_sheet)
      out = true
      unless profile.nil? || time_sheet.nil? || usercommissionroles.nil? || usercommissionroles.empty? || to_usercommissionrole.nil? then
        if params[:profile_type].eql?(LockEmail::LIST[4]) then
          out = false
        elsif !params[:tsh_id].nil? && TimeSheetHour.find(params[:tsh_id].to_i).matter_id == to_usercommissionrole.user.documents.first.profile.profile_keys.find_by(key: "Materias:").profile_values.first.value.to_i then
          matter_of_profile = to_usercommissionrole.user.documents.first.profile.profile_keys.find_by(key: "Materias:").profile_values.first.value.to_i
          arr = []
          to_usercommissionrole.user.usercommissionroles.where.not(id: to_usercommissionrole.id).where.not(commission_id: 1).find_each do |e| arr.push(e.commission_id) end
          arr2 = []
          TimeSheet.where(:commission_id => arr).find_each do |e| arr2.push(e.time_sheet_hours.where(matter_id: matter_of_profile).
            pluck(:from_hour,:from_min,:to_hour,:to_min,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday,:sunday).uniq) end
          obj=TimeSheetHour.find(params[:tsh_id].to_i)
          unless arr2.include?([[obj.from_hour,obj.from_min,obj.to_hour,obj.to_min,obj.monday,obj.tuesday,obj.wednesday,obj.thursday,obj.friday,obj.saturday,obj.sunday]]) then
            out = false
          end
        end
      end
      out
    end

end
