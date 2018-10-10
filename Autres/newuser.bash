#!/bin/bash

# CLD1
# Quentin, Davide, Antonio
# v 1.0
# Create a new host user, with web-server service and user database

webPath='/var/www'
homePath='/home'
group='www-data'
passwordCheck=0

#########################################
# Functions
#########################################

function readValue()
{

#read the input value and apply the filter

local string=""

read  string
string=${string//[^a-zA-Z0-9_.]/}
if [ "$string" == "" ]
	then eval $1=""
	else eval $1=$string
fi
}

function checkAnswer()
{

#get Yes or Not value else not mach

local answer=""

while [ "$answer" != "y" ] && [ "$answer" != "Y" ] && [ "$answer" != "n" ] && [ "$answer" != "N" ]
do
	read answer
	if [ "$answer" == "y" ] || [ "$answer" == "Y" ]
 		then return 1
	fi
	if [ "$answer" == "n" ] || [ "$answer" == "N" ]
 		then return 0
	else
 	       echo -n "select Y or N [Enter]: "
	fi
done
}


function getUserName()
{

# get and verify the name of the new user

local condition=0
local name=""

while [ $condition -eq 0 ]
do

#read the name of the new user
echo -n "Insert the new user [Enter]: "
readValue name

# id system command to show current user
# return 0 if user do not exists else return 1
id $name > 2&>1 > /dev/null

#check the return value of $? and the value of name
if [ $? -eq 0 ] || [ "$name" == "" ]
        then
                # the user already exists or value is empty
                if [ "$name" == "" ]
			then echo "Value is empty!"
			else echo "The user '"$name"' already exsit!"
		fi
		condition=0
        else
                #user does not exists
                condition=1
fi
done
eval $1=$name #return value
}


function getUserDomaine()
{

#get and verify the name of the new user's domaine

local domaine=""
local condition=0

while [ $condition -eq 0 ]
do

#read the name of the domaine for the new user
echo -n "Insert the domaine for" $userName "(ex: www.carboni.ch) [Enter]: "
readValue domaine

# control is the domaine already exists
# return 0 if domaine exists else return 1
[ -f /etc/nginx/sites-available/$domaine ]

#check the return value of $? and the value of domaine
if [ $? -eq 0 ] || [ "$domaine" == "" ]
        then
                # domaine already exists or value is empty
		if [ "$domaine" == "" ]
                        then echo "Value is empty!"
                        else echo "The domaine '"$domaine"' already exsit!"
                fi
                condition=0
        else
                #domaine does not exists
                condition=1

fi
done
eval $1=$domaine #return value
}

function getUserDB()
{

#get and verify the database name of the new user

local condition=0
local dbName=""

while [ $condition -eq 0 ] && [ $passwordCheck -eq 0 ]
do

#read the admin password to acces in to mariadb
echo -n "Insert the Password of MariaDB Admin [Enter]: "
read -s adminPassword
echo

# check if the root password is correct
# return 0 if ok else return 1
mysql --user=root --password=$adminPassword -e exit > 2&>1 > /dev/null;

if [ $? -eq 1 ]
        then
                # the user already exists
                # what do you want to do? Do you wnat repeat or abort the process?
                echo "The admin password is incorrect!"
                condition=0 #to repeat
        else
                condition=1 #to continue
fi
done
passwordCheck=1

condition=0
while [ $condition -eq 0 ]
do

#read the name of the domaine for the new user Database
echo -n "Insert the new database name of the new user [Enter]: "
readValue dbName

#check if the domaine already exists
mysql --user=root --password=$adminPassword --batch --skip-column-names -e "SHOW DATABASES LIKE '"$dbName"';" | grep "$dbName" >/dev/null;

#reading the return value of adduser with the variable $?
if [ $? -eq 0 ] || [ "$dbName" == "" ]
        then
                # the database already exists or value is empty
		if [ "$dbName" == "" ]
                        then echo "Value is empty!"
                        else echo "The database  '"$dbName"' already exsit!"
                fi
                condition=0
        else
                #database does not exists
                condition=1
fi
done
eval $1=$dbName
}

function checkRes()
{

#print values of the new users and get a confirmation

local res=0

echo ""
echo ""
echo "User Name: "$userName
echo "User Domaine: "$userDomaine
echo "User DB: "$userDB
echo ""
echo -n "All informations are corrects? [y/n]: "
checkAnswer
res=$?
eval $1=$res
}

function addNewUser()
{

#add new user in to the system

local userPassword
echo

#get the password
echo -n "Insert the password of the new user account [Enter]: "
read -s userPassword
echo
#add user
useradd -m -d $homePath/$userName -s /bin/bash -p $(echo $userPassword | openssl passwd -1 -stdin) $userName

}

function changeUserFoldersPermissions()
{

#change the permissions of all folder's user

# creat a new web folder for the domaine's user
mkdir -p $webPath/$userDomaine
mkdir -p $webPath/$userDomaine/public_html

# change user owner user and group  for the web folder
chown -R ${userName}:${group} ${webPath}/$userDomaine

# change user permssion for the user personal folder
chmod g-x,o-x ${homePath}/${userName}

#change user permission for the user web folder
chmod o-x ${webPath}/${userDomaine}
}

function createUserWeb()
{

#create a new web hosting for the user

#creat a new web file conf for the new site web
touch  /etc/nginx/sites-available/$userDomaine

echo "server{
        listen   80;
        server_name $userDomaine;
        access_log $webPath/$userDomaine/access.log;
        error_log $webPath/$userDomaine/error.log;
        root   /var/www/$userDomaine/public_html;
        index  index.html index.htm index.php;
        location / {
        try_files \$uri \$uri/ =404;
        }
        location ~ \.php$ {
        fastcgi_pass unix:/var/run/php5-fpm.sock;
        include snippets/fastcgi-php.conf;
        }
}
" > /etc/nginx/sites-available/$userDomaine

#enable the new user site web for the new domaine
ln -s /etc/nginx/sites-available/$userDomaine /etc/nginx/sites-enabled

#create a personal folder web link in to the home user folder
ln -s /var/www/$userDomaine/public_html $homePath/$userName/public_html
}

function createUserDB()
{

#add a new user to mariaDB and create a new database for user

#add user to mysql
mysql --user=root --password=$adminPassword <<EOF
CREATE USER '$userName'@'%' IDENTIFIED BY '$userPassword';
CREATE DATABASE $userDB;
GRANT ALL PRIVILEGES ON $userDB.* TO '$userName'@'%';
flush privileges;
quit
EOF
}

function createInfoFile()
{

touch $homePath/$userName/infoUser.txt

echo "
Welcome!

Your personal informaions:

	- User name: $userName
	- User password: XXXXXXXX (send password via mail)
	- Web domaine: $userDomaine
	- MariaDB login name: $userName
	- MariaDB login password: XXXXXXX (send password via mail)
	- Database name: $userDB
" > $homePath/$userName/infoUser.txt
}


function getUserData()
{

#get all user data to create a new account, web hosting and database

risu=0

while [ $risu -eq 0 ]
do
        clear
        echo "Welcome to the Web Master utility"
        echo ""
        getUserName userName		#get user name
        getUserDomaine userDomaine	#get user domaine
        getUserDB userDB		#get user database
        checkRes risu			#get confirmation by admin
done
}


function writeUserData()
{

#create a new user, domaine and database

addNewUser				#add new user
changeUserFoldersPermissions		#change permissions
createUserWeb				#add new web hosting
createUserDB				#add a new database  
echo
echo $userName "has been added with the domaine " $userDomaine "!Bye"
}

function restartServices()
{
echo "Restart web server..."
service nginx restart         #restart server web
echo "Server web restart!"
echo "Restart mariaDb server..."
service mysql restart         #restart mariaDB server
echo "mariaDB restarted!"
}

#########################################################################################
# Start
#########################################################################################

getUserData			#get all user data informations
writeUserData			#write all user data informations
createInfoFile			#create an info file for user in the personal home folder
restartServices			#restart web server and mariaDB server

