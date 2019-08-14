#!/bin/bash
sudo apt-get update
sudo apt-get install -y nginx php7.2-fpm php7.2-mysql php7.2-mbstring php7.2-gd nfs-common
sudo echo "${wordpress_efs_dns_name}:/ /var/www/html nfs defaults,vers=4.1 0 0" >> /etc/fstab
sudo mount -a

# Create nginx config file
cat <<'EOF' > /etc/nginx/sites-available/default
# Default server configuration
#
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html/wordpress;

        index index.php index.html;

        server_name _;

        location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
              fastcgi_pass      unix:/run/php/php7.2-fpm.sock;
              fastcgi_index     index.php;
              fastcgi_param     SCRIPT_FILENAME $document_root$fastcgi_script_name;
              include           fastcgi_params;
        }

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        location ~ /\.ht {
               deny all;
        }
}
EOF

# Check iw we already have WP (new instance in ASG)
FILE=/var/www/html/wordpress/wp-config.php
if test -f "$FILE"; then
    echo "We have wordpress so skip downloading"
else
    sudo wget -P /var/www/html/ https://wordpress.org/latest.tar.gz
    sudo tar -xf /var/www/html/latest.tar.gz -C /var/www/html/

# Create wordpress config file
cat <<'EOF' > /var/www/html/wordpress/wp-config.php
<?php
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '${db_name}' );

/** MySQL database username */
define( 'DB_USER', '${username}' );

/** MySQL database password */
define( 'DB_PASSWORD', '${password}' );

/** MySQL hostname */
define( 'DB_HOST', '${hostname}' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
* Authentication Unique Keys and Salts.
*
* Change these to different unique phrases!
* You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
* You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
*
* @since 2.6.0
*/
define('AUTH_KEY',         ';mPi$T=5g7?t/{hyC>eZ:(e|mi/~hgUCSYE7C4euR3Dh+yr:<cy6`p*ByDr9h-;E');
define('SECURE_AUTH_KEY',  '>4w%tp^y?s_+7T?qa_)A4zgDm=C0kfGMzR74dmg/`sy!2#5g[P^vL&%87ODIc{RN');
define('LOGGED_IN_KEY',    'Cs8FOG)Bztw)rjCit$6o^]aF~Mq2g7W1%u>@aE7?lP=dSqJPR%^:Qpm3~`o%/lwh');
define('NONCE_KEY',        '9AvvG:R+3ctM4wVc|-Ub(zVd0/L3qsg#d{Cv`KTK%xd=m-n9hq9#|E<6vdyT&SA+');
define('AUTH_SALT',        ',<iS6&R6;lOR4omrOXD/r0 r;~#2eR [V;+`| !h<[XiuA& YY(YjS[UIK}-Lu;F');
define('SECURE_AUTH_SALT', '.&9$-,HWygJzn4N.m+^B}>uRW#Y,m,az!Ovt_qdMhf(.2]3Fbm3&]r!EO?RaRuX1');
define('LOGGED_IN_SALT',   'D`X<a[rIlXX+^3=n+0G4_ 8` ?~+R7C]W?*WHLRxcQ~L_k5aU6UG)MS~a? 4iz!d');
define('NONCE_SALT',       'Se/e;#|I$s>k,!Ut`8qVHUJ<[A_k8#{[x)X7GRhTj;Lua!)[``AQaI%[liEAPWs;');

$table_prefix = 'wp_';

define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
EOF

    chmod 644 /var/www/html/wordpress/wp-config.php
    chown -R www-data:www-data /var/www/html/wordpress/
fi 

# Restart nginx
sudo systemctl restart nginx