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

$ tree -L 2
├── app
│   ├── assets
│   ├── channels
│   ├── controllers
│   ├── helpers
│   ├── jobs
│   ├── mailers
│   ├── models
│   └── views
├── bin
│   ├── bundle
│   ├── rails
│   ├── rake
│   ├── setup
│   ├── update
│   └── yarn
├── cable
│   └── config.ru
├── config
│   ├── application.rb
│   ├── boot.rb
│   ├── cable.yml
│   ├── database.yml
│   ├── environment.rb
│   ├── environments
│   ├── initializers
│   ├── locales
│   ├── puma.rb
│   ├── routes.rb
│   ├── secrets.yml
│   ├── sidekiq.yml.erb
│   ├── spring.rb
│   └── storage.yml
├── config.ru
├── db
│   ├── schema.rb
│   └── seeds.rb
├── docker-compose.yml
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── lib
│   ├── assets
│   └── tasks
├── log
├── public
│   ├── 404.html
│   ├── 422.html
│   ├── 500.html
│   ├── apple-touch-icon.png
│   ├── apple-touch-icon-precomposed.png
│   ├── favicon.ico
│   └── robots.txt
├── Rakefile
├── README.md
├── storage
├── test
│   ├── application_system_test_case.rb
│   ├── controllers
│   ├── fixtures
│   ├── helpers
│   ├── integration
│   ├── mailers
│   ├── models
│   ├── system
│   └── test_helper.rb
├── tmp
│   ├── cache
│   └── miniprofiler
└── vendor
    └── assets

35 directories, 36 files

$ docker-compose up --build

LUEGO, EN UNA SEGUNDa TERMINAL:

$ cd <path>/GIDAPPF/gidappf
$ docker-compose exec --user "$(id -u):$(id -g)" website rails db:reset
$ docker-compose exec --user "$(id -u):$(id -g)" website rails db:migrate

AHORA SE PUEDE VISITAR EL SITIO http://localhost:3000
