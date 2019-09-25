# Resumen

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

**Teniendo un linux con las siguientes dependencias:**
* git
* docker
* docker-compose
* bash (para la ejecución del despliegue)

**Ultimas versiones Testeadas de las dependencias indicadas**
* git version 2.22.0
* Docker version 18.09.7-ce, build 2d0083d657
* docker-compose version 1.24.1, build unknown
* GNU bash, versión 5.0.9(1)-release (x86_64-pc-linux-gnu)

PARA SUMARSE AL DESARROLLO DEL PROYECTO, Y EJECUTAR EL PROYECTO, DESDE UNA TERMINAL:
``` [bash]
  $ systemctl start docker #(para encender el proceso de docker si no se habilito antes)
  $ git clone https://github.com/unajpps2018asc/GIDAPPF.git
  $ cd GIDAPPF/gidappf
```
* ----- Descargar .env dentro de la carpeta GIDAPPF/gidappf descargándolo desde --------
* https://drive.google.com/file/d/11GeFXzpwyMSF0GsswrxIq0LwyVJU7_Gu/view?usp=sharing
* Luego continuar con el comando de despliegue:
``` [bash]
  $ docker-compose up --build -d && docker-compose exec --user "$(id -u):$(id -g)" website rails db:setup && sudo rm -R storage/!(seeds)
```

* AHORA SE PUEDE VISITAR EL SITIO http://localhost:3000 y crear el primmer usuario admin.
* En el caso de necesitar poblar la base de datos con valores de muestra, ingresar en la terminal:
``` [bash]
  $ docker-compose exec --user "$(id -u):$(id -g)" website rake db:seed:populate_show
```

* Si se apaga el servidor anfitrión y es necesario reiniciar el proyecto, en la terminal:
``` [bash]
  $ docker-compose up -d
```

En el caso en el que en el servidor anfitrión mantenga el servicio 'inode-tools', indicador de eventos de FileSystem los mensajes de este servicio se detendrán con:
``` [bash]
  $ sudo killall inotifywait
```
No significaria un problema porque es un proceso creado por un script de sincronismo, en todo caso el script volvera a activarlo al reiniciar el sistema.
