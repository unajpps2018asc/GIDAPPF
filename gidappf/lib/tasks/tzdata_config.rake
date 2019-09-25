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
# Archivo GIDAPPF/gidappf/lib/tasks/tzdata_config.rake                    #
###########################################################################
namespace :configtzdata do
  desc "[GIDAPPF]: Configuring tzdata..."
  task call_sys: :environment do
    system ("echo '#{ENV['TZ']}' >> /etc/timezone");
    system ("cp /usr/share/zoneinfo/#{ENV['TZ']} /etc/localtime");
    if File.exist?("/etc/timezone") && File.exist?("/etc/localtime") then
      system ("echo '[GIDAPPF]: Configuring tzdata... complete!' ")
    else
      system ("echo '[GIDAPPF]: Configuring tzdata... ERROR' ")
    end
  end
end
