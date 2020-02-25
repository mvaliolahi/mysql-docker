#### Mysql + phpMyAdmin setup using bash!


###### Setup

	$ ./mysql-docker.sh 123456 3306


###### Start Container 

	$ ./mysql-docker.sh


###### Import data

	$ cat data.sql | docker exec -it mysql57 mysql -uroot -p123456789 db-name

