# Initial 
DATABASE_PASSWORD="123456789";
DATABASE_PORT=3306;

# get database password from user input.
if [ ! -z "$1" ]; then
    DATABASE_PASSWORD=$1;
fi	

# get database port from user input.
if [ ! -z "$2" ]; then
    DATABASE_PORT=$2;
fi	


# Create Volume
    docker volume create mysql-data > /dev/null 2>&1;

# Create Network. 
    docker network create mysql-network  > /dev/null 2>&1;

# Pull MySQL Image.
if [[ "$(docker images -q mysql:5.7 2> /dev/null)" == "" ]]; then
    docker pull mysql:5.7;
fi

# Pull PHPMyAdmin Image.
if [[ "$(docker images -q phpmyadmin/phpmyadmin 2> /dev/null)" == "" ]]; then
  docker pull phpmyadmin/phpmyadmin;
fi

# Start MySQL
MYSQL_CONTAINER=$(docker run --name mysql57 \
           --net=mysql-network \
           -p $DATABASE_PORT:3306 \
           -e MYSQL_ROOT_PASSWORD=$DATABASE_PASSWORD \
           -v mysql-data:/var/lib/mysql \
           -d mysql:5.7  2>&1
);
if [[ $MYSQL_CONTAINER  ]]; then 
    docker start mysql57 > /dev/null 2>&1;
    echo "mysql57 container start again!";
fi	


# Run PHPMyAdmin 
PHP_MY_ADMIN=$(docker run --name php-my-admin \
           --net=mysql-network \
           -e MYSQL_ROOT_PASSWORD=$DATABASE_PASSWORD \
           -e PMA_HOST="mysql57" \
           -e PMA_PORT=$DATABASE_PORT \
           -p 8080:80 \
           -d phpmyadmin/phpmyadmin 2>&1);

if [[ $PHP_MY_ADMIN  ]]; then 
    docker start php-my-admin > /dev/null 2>&1;
    echo "php-my-admin container start again!";
fi	
