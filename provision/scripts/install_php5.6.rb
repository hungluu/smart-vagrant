#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install php5.6
command = LVCommand.shared_command
command.push_install_message(["PHP 5.6"])
command.push_install([
    "python-software-properties",
    "php5.6",
    "libapache2-mod-php5.6",
    "php5.6-mcrypt"
  ])
# Applying new php version to apache2
command.push_message("Apply PHP 5.6 to Apache2 ...")
command.push("a2dismod php5 2>dev>null")
command.push("a2dismod php7 2>dev>null")
command.push("a2enmod php5.6 2>dev>null")
