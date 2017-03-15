#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
lv.require_apt_repo("postgresql-9.5")
lv.push_install_message(["Postgresql 9.5 For PHP 5"])
lv.push_install(["postgresql-9.5", "postgresql-contrib", "php5-pgsql"], '-qq --allow-unauthenticated')
