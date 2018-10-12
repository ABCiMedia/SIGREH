# SIGREH
Sistema de Gestão de Recursos Humanos

### INSTALLATION:
        
        git clone git@github.com:ABCiMedia/SIGREH.git
        npm install
        
### DEPENDENCIES
You need:
 - NodeJs
 - Mysql
 
### INITIAL CONFIGURATIONS
Inside the file models/credentials.js set:
 - database;
 - username;
 - password;
    
### RUN

        npm start
        
You need to have NodeJs installed.

### CREATE SUPER USER

    node create_super_user.js -u <username> -p <password>
    
### POPULATE THE DATABASE WITH EXAMPLE DATA

    node populate_person.js
