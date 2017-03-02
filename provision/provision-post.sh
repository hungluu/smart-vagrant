echo "* End checking dependencies ..."
echo "* Removing unused packages ..."
sudo apt-get -y autoremove 2>/dev/null
sudo service apache2 restart
#=====================================
# Start editing from here
