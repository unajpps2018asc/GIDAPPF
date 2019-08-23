###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#       <<Gestión Integral de Alumnos Para el Proyecto Fines>>            #
# Tutores:                                                                #
#       - UNAJ: Dr. Ing. Morales, Martín                                  #
#       - INSTITUCION: Ing. Cortes Bracho, Oscar                          #
#       - TAPTA: Dra. Ferrari, Mariela                                    #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
###########################################################################
    class HomeController < ApplicationController
        def index
          if current_user.documents.present? && current_user.documents.first.profile.present?
            @my_profile=current_user.documents.first.profile
          end
        end

        def search
          @search = params[:search].split(' ')
          unless @search.first.nil?
            words=@search.dup
            @profiles = Profile.where( id: ProfileKey.where( id: ProfileValue.
              where("value LIKE :query", query: "%#{ActiveRecord::Base.send(:sanitize_sql_like,words.shift)}%"
            ).pluck(:profile_key_id)).pluck(:profile_id))
            words.each do |word|
              @profiles += Profile.where( id: ProfileKey.where( id: ProfileValue.
                where("value LIKE :query", query: "%#{ActiveRecord::Base.send(:sanitize_sql_like,word)}%"
              ).pluck(:profile_key_id)).pluck(:profile_id))
            end
          else
            @profiles = Profile.all
          end
        end
    end
