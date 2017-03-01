#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install php5
echo "Installing php5.6 ..."
sudo apt-get -y install python-software-properties 2>dev>null
sudo apt-get -y install php5 libapache2-mod-php5 php5-mcrypt 2>dev>null
# Applying new php version to apache2
echo "Apply php5.6 to apache2 ..."
sudo a2dismod php5.6 2>dev>null
sudo a2enmod php5 2>dev>null
sudo service apache2 restart
