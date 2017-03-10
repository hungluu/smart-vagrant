#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
command = LampVagrant.command
# command.push(command.restart_service("apache2"))
command.push_install_message(["Postgresql 9.5 For PHP 5.6"])
command.push_install(["postgresql-9.5", "php5.6-pgsql"], '-qq --allow-unauthenticated')
