commande à faire 

	sudo apt update
	sudo apt install nginx

	lancer nginx
	service nginx start

	on peut le voir sur l'adresse ip du serveur, la page d'accueil de NGINX



	Nginx on Debian 9 has one server block enabled by default that is configured to serve documents out of a directory at /var/www/html. While this works well for a single site, it can become unwieldy if you are hosting multiple sites. Instead of modifying /var/www/html, let's create a directory structure within /var/www for our example.com site, leaving /var/www/html in place as the default directory to be served if a client request doesn't match any other sites.



	<html>
    <head>
        <title>Welcome to Example.com!</title>
    </head>
    <body>
        <h1>Success!  The example.com server block is working!</h1>
    </body>
</html>

 Il faut faire le truck de base, et dans le script, à chaque fois, ajouter le truck avec le site de base 
                                                                  
      server_name 172.17.208.69;                                  
                                                                  
                                                                  
      location / {                                                
              return 418;                                         
      }                                                           
                                                                  
      location /proj1/ {                                          
              alias /var/www/proj1;                               
              try_files $uri /index.html index.php;               
      }                                                           
                                                                  
      location /proj2/ {                                          
               alias /var/www/proj2;                              
               try_files $uri /index.html index.php;              
      }                                                           
                                                                  
      location /proj3/ {                                          
              alias /var/www/proj3;                               
              try_files $uri /index.html index.php;               
      }                                                           
                                                                  


Il faut le "x" dans le "other" afin d'y accéder sur la page web.

Il faut encore tester le truck du prof voir si sa marche.