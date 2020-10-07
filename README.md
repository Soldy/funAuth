# fun Auth.

## setup 

### 1. create a mysql user and table

### 2. Fill the conf.php

```php


$super_config = [];
$super_config['sql']=[];
$super_config['sql']['user']='user';
$super_config['sql']['password']='password';
$super_config['sql']['db']='database';
$super_config['sql']['host']='host';

```

### 3. made the web dir to the web documentum root:

Like this.
```apache 

<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName  Name
        ServerAlias Alias
        DocumentRoot /var/www/funaAuth/web/
        <Directory  /var/www/funAuth/web/ >
                SetInputFilter DEFLATE
                Options Indexes FollowSymLinks MultiViews
                Options -Indexes
                AllowOverride None
                Order allow,deny
                allow from all
                Require all granted
        </Directory>
        <IfModule mod_headers.c>
             Header always append X-Frame-Options SAMEORIGIN
        </IfModule>
</VirtualHost>

```



