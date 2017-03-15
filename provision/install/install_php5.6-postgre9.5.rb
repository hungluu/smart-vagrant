#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
# command.push(command.restart_service("apache2"))
lv.require_apt_repo("postgresql-9.5")
lv.push_install_message(["Postgresql 9.5 For PHP 5.6"])
lv.push_install(["postgresql-9.5", "php5.6-pgsql"], '-qq --allow-unauthenticated')
