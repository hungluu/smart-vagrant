#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
command = lv.command
package_list = ["postgresql-9.5", "postgresql-contrib", "php5-pgsql"]
lv.require_apt_repo("postgresql-9.5")
lv.push_install_message(["Postgresql 9.5 For PHP 5"])
lv.push_install_message(package_list, 1)
install_params = case lv.os
  when "centos"
    "-y -q"
  else
    "-qq --allow-unauthenticated"
  end
command.push(command.install(package_list, install_params))
