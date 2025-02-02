#!/bin/bash

# Fungsi untuk logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Fungsi untuk error handling
handle_error() {
    log "ERROR: $1"
    exit 1
}

# Pastikan script dijalankan sebagai root
if [ "$(id -u)" != "0" ]; then
    handle_error "Script harus dijalankan dengan sudo"
fi

# Fungsi untuk validasi IP address
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        return $?
    else
        return 1
    fi
}

# Fungsi untuk membaca input
get_input() {
    local prompt="$1"
    local default="$2"
    local validation_func="$3"
    local input
    local valid=false
    
    while [ "$valid" = false ]; do
        exec < /dev/tty
        read -p "$prompt" input
        
        if [ -z "$input" ] && [ ! -z "$default" ]; then
            input="$default"
        fi
        
        if [ ! -z "$validation_func" ]; then
            if $validation_func "$input"; then
                valid=true
            else
                log "Input tidak valid, silakan coba lagi"
                continue
            fi
        else
            valid=true
        fi
    done
    echo "$input"
}

# Main script starts here
log "Memulai konfigurasi server..."

# Fix untuk dpkg yang interrupted
log "Memperbaiki package yang interrupted..."
dpkg --configure -a || handle_error "Gagal memperbaiki dpkg yang interrupted"

# Minta input di awal
user_ip=$(get_input "Masukkan IP address (contoh: 192.168.1.1): " "" validate_ip)
user_domain=$(get_input "Masukkan nama domain (contoh: smkeki.sch.id): ")
mysql_root_password=$(get_input "Masukkan password untuk root MySQL: ")
phpmyadmin_password=$(get_input "Masukkan password untuk phpMyAdmin: ")
samba_username=$(get_input "Masukkan username untuk Samba: ")
samba_password=$(get_input "Masukkan password untuk Samba: ")

# Update sistem
log "Updating system packages..."
export DEBIAN_FRONTEND=noninteractive

# Bersihkan apt cache dan fix dependencies
apt-get clean
apt-get autoremove -y
apt-get autoclean

# Update dengan proper error handling
if ! apt-get update -y; then
    log "WARNING: Update gagal, mencoba fix..."
    rm -f /var/lib/apt/lists/lock
    rm -f /var/cache/apt/archives/lock
    rm -f /var/lib/dpkg/lock*
    dpkg --configure -a
    apt-get update -y || handle_error "Gagal melakukan update sistem"
fi

# Upgrade dengan proper error handling
if ! apt-get upgrade -y; then
    log "WARNING: Upgrade gagal, mencoba fix..."
    dpkg --configure -a
    apt-get upgrade -y || handle_error "Gagal melakukan upgrade sistem"
fi

# Tambah repository universe
add-apt-repository universe -y || handle_error "Gagal menambahkan repository universe"

# Set konfigurasi otomatis untuk MySQL dan phpMyAdmin
debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $mysql_root_password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $phpmyadmin_password"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

# Install paket yang diperlukan
packages="bind9 apache2 mysql-server apache2-utils phpmyadmin samba"
for package in $packages; do
    apt-get install -y $package || handle_error "Gagal menginstall $package"
done

# Konfigurasi DNS
cat > /etc/resolv.conf <<EOL
nameserver $user_ip
nameserver 8.8.8.8
search $user_domain
options edns0 trust-ad
EOL

# Konfigurasi zona Bind9
reversed_ip=$(echo "$user_ip" | awk -F. '{print $3"."$2"."$1}')

cat > /etc/bind/named.conf.local <<EOL
# Custom SMK zones
zone "$user_domain" {
     type master;
     file "/etc/bind/smk.db";
 };

zone "$reversed_ip.in-addr.arpa" {
     type master;
     file "/etc/bind/smk.ip";
 };
EOL

# Konfigurasi file zona
cat > /etc/bind/smk.db <<EOL
\$TTL    604800
@       IN      SOA     ns.$user_domain. root.$user_domain. (
                        $(date +%Y%m%d)01 ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;
@       IN      NS      ns.$user_domain.
@       IN      MX 10   $user_domain.
@       IN      A       $user_ip
ns      IN      A       $user_ip
www     IN      CNAME   ns
mail    IN      CNAME   ns
ftp     IN      CNAME   ns
ntp     IN      CNAME   ns
proxy   IN      CNAME   ns
EOL

# Konfigurasi file PTR
octet=$(echo "$user_ip" | awk -F. '{print $4}')
cat > /etc/bind/smk.ip <<EOL
@       IN      SOA     ns.$user_domain. root.$user_domain. (
                        $(date +%Y%m%d)01 ; Serial
                        604800    ; Refresh
                        86400     ; Retry
                        2419200   ; Expire
                        604800 )  ; Negative Cache TTL
;
@       IN      NS      ns.$user_domain.
$octet  IN      PTR     ns.$user_domain.
EOL

# Konfigurasi Apache
cat > /etc/apache2/sites-available/000-default.conf <<EOL
<VirtualHost *:80>
        ServerAdmin webmaster@$user_domain
        ServerName $user_domain
        ServerAlias www.$user_domain
        DocumentRoot /var/www/html
        
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/html>
                Options Indexes FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>
</VirtualHost>
EOL

# Buat direktori dan set permissions
mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

# Buat index.php
cat > /var/www/html/index.php <<EOL
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to $user_domain</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1 { color: #333; }
    </style>
</head>
<body>
    <h1>Selamat Datang di Server $user_domain</h1>
    <?php phpinfo(); ?>
</body>
</html>
EOL

# Set permissions
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Konfigurasi Samba
useradd -m $samba_username 2>/dev/null || true
echo -e "$samba_password\n$samba_password" | passwd $samba_username

cat > /etc/samba/smb.conf <<EOL
[global]
   workgroup = WORKGROUP
   server string = Samba Server %v
   netbios name = $(hostname)
   security = user
   map to guest = bad user
   dns proxy = no

[www]
   path = /var/www/html
   browseable = yes
   writeable = yes
   valid users = $samba_username
   create mask = 0644
   directory mask = 0755
   force user = www-data
EOL

# Set Samba password
echo -e "$samba_password\n$samba_password" | smbpasswd -s -a $samba_username

# Konfigurasi phpMyAdmin
echo "Include /etc/phpmyadmin/apache.conf" >> /etc/apache2/apache2.conf

# Aktifkan modul Apache yang diperlukan
a2enmod rewrite
a2enmod ssl
a2ensite 000-default.conf

# Restart layanan
systemctl restart bind9
systemctl restart apache2
systemctl restart smbd
systemctl restart mysql

# Enable services at startup
systemctl enable bind9
systemctl enable apache2
systemctl enable smbd
systemctl enable mysql

log "==== Konfigurasi Selesai ===="
log "Domain: $user_domain"
log "IP Address: $user_ip"
log "phpMyAdmin URL: http://$user_ip/phpmyadmin"
log "Samba share tersedia di: //$user_ip/www"
log "Username Samba: $samba_username"