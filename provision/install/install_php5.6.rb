#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install php5.6
lv = LampVagrant.instance
command = lv.command
lv.require_apt_repo("php")
lv.push_install_message(["PHP 5.6"])
case lv.os
when "centos"
  package_list = ["php56w", "php56w-opcache", "php56w-mbstring", "php56w-pdo"]
  lv.push_install_message(package_list, 1)
  command.push(command.install(package_list))
else
  package_list = ["python-software-properties", "php5.6", "libapache2-mod-php5.6", "php5.6-mcrypt", "php5.6-mbstring", "php5.6-pdo"]
  lv.push_install_message(package_list, 1)
  command.push(command.install(package_list))
  # Applying new php version to apache2
  command.push_message("Apply PHP 5.6 to Apache2 ...")
  command.push("a2dismod php5 2>dev>null")
  command.push("a2dismod php7 2>dev>null")
  command.push("a2enmod php5.6 2>dev>null")
end