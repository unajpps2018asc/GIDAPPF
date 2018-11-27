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
# Archivo GIDAPPF/Dockerfile                                              #
###########################################################################
FROM ruby:2.5.3-alpine3.8

RUN apk update && apk upgrade && apk add build-base nodejs postgresql-dev nano tzdata

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

LABEL maintainer="Daniel Rosatto <danielrosatto@gmail.com>"

EXPOSE 25/tcp 465/tcp 587/tcp

CMD puma -C config/puma.rb
