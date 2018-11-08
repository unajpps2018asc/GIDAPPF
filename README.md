Resumen

La Práctica Profesional Supervisada (PPS) es un desarrollo informático que consiste en la creación de un software original a nombre del Programa Tecnologías de la información y la 
comunicación (TIC) en aplicaciones de interés social, para la carrera de Ingeniería en Informática, perteneciente al Instituto de Ingeniería y Agronomía. El proyecto gestionará los 
datos de alumnos para mantener la historia educativa de cada estudiante del Plan Fines. Dejará a disposición de los administradores, coordinadores y secretarios, información 
estadística sobre los ingresantes y estudiantes para  realizar el seguimiento y planificar las comisiones para el próximo ciclo.  
El software, solicitado por la coordinadora de la Unidad de Vinculación y Calidad Educativa Regional, profesora María Elena Zambella, tiene la finalidad de dar soporte informático a 
medida al sector de la administración que se encarga de dar de alta y seguimiento a los estudiantes del Plan Fines. Actualmente, este sector documentan el rendimiento de estos 
estudiantes con un sistema implementado mediante herramientas de ofimática estándares. La administración del Plan Fines, con quienes también se realizará la presente práctica 
profesional, está compuesta por el Secretario del Plan Fines, el profesor Rubén Romero, y por el Coordinador del Plan, el profesor Cristian Pidalá.
El soporte informático consiste en el desarrollo de una aplicación web que mantenga los datos registrados actualmente y permita manipularlos eficazmente para beneficio de toda la 
comunidad educativa del Plan Fines. Para ello, se deberá interpretar el diseño y la funcionalidad de la aplicación web, realizando una investigación sobre la administración actual del 
Plan Fines. Se debe lograr un acuerdo sobre todas las funcionalidades del sistema a fin de que este que cumpla con las siguientes condiciones:
Debe ser lo suficientemente útil para reemplazar al sistema actual.
Debe ser pasible de ser mantenido o sustentable por el soporte de los servidores de la Universidad Nacional Arturo Jauretche.
Debe ser finalizado a tiempo para su uso en el año en curso, dado el plazo de la Práctica Profesional Supervisada y las necesidades del sector.
Además del proyecto de desarrollo de la aplicación web a medida del Plan Fines, utilizando una metodología ágil, deberá crearse un manual del usuario. 

Teniendo un linux con las siguientes dependencias:
git
ruby
docker
docker-compose

PARA SUMARSE AL DESARROLLO DEL PROYECTO, HACER:

$ git clone https://github.com/unajpps2018asc/GIDAPPF.git

$ cd GIDAPPF/gidappf

$ ls -lh
total 80K
drwxr-xr-x 10 user users 4,0K oct 30 15:42 app
drwxr-xr-x  2 user users 4,0K oct 30 15:42 bin
drwxr-xr-x  2 user users 4,0K oct 30 15:42 cable
drwxr-xr-x  5 user users 4,0K oct 30 15:42 config
-rwxr-xr-x  1 user users  130 oct 30 15:42 config.ru
drwxr-xr-x  2 user users 4,0K oct 30 15:42 db
-rwxr-xr-x  1 user users  853 oct 30 15:42 docker-compose.yml
-rwxr-xr-x  1 user users  274 oct 30 16:07 Dockerfile
-rwxr-xr-x  1 user users 2,4K oct 30 15:42 Gemfile
-rwxr-xr-x  1 user users 5,0K oct 30 15:42 Gemfile.lock
drwxr-xr-x  4 user users 4,0K oct 30 15:42 lib
drwxr-xr-x  2 user users 4,0K oct 30 15:42 log
drwxr-xr-x  2 user users 4,0K oct 30 15:42 public
-rwxr-xr-x  1 user users  229 oct 30 15:42 Rakefile
-rwxr-xr-x  1 user users  374 oct 30 15:42 README.md
drwxr-xr-x  2 user users 4,0K oct 30 15:42 storage
drwxr-xr-x  9 user users 4,0K oct 30 15:42 test
drwxr-xr-x  4 user users 4,0K oct 30 15:42 tmp
drwxr-xr-x  3 user users 4,0K oct 30 15:42 vendor

$ docker-compose up --build

LUEGO, EN UNA SEGUNDa TERMINAL:

$ cd <path>/GIDAPPF/gidappf
$ docker-compose exec --user "$(id -u):$(id -g)" website rails db:reset
$ docker-compose exec --user "$(id -u):$(id -g)" website rails db:migrate

AHORA SE PUEDE VISITAR EL SITIO http://localhost:3000
