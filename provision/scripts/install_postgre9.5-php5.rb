#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
command = LVCommand.shared_command
command.push_install_message(["Postgresql 9.5 For PHP 5"])
command.push_install(["postgresql-9.5", "postgresql-contrib", "php5-pgsql"], '-y -qq --allow-unauthenticated')