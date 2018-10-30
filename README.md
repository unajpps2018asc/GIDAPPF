# GIDAPPF
Proyecto para el Centro de​ Política y Territorio (CPyT) de la Univerrsidad Nacional Arturo Jauretche. Sistema de gestión integrada de alumnos para el Plan Fines. G.I.D.A.P.P.F.

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
