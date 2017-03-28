#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
command = lv.command
case lv.os
when "centos"
  lv.require_apt_repo("postgre9.5")
  package_list = ["postgresql95-server", "postgresql95", "php5.6-pgsql"]
  lv.push_install_message(["Postgresql 9.5 For PHP 5.6"])
  lv.push_install_message(package_list, 1)
  command.push(command.install(package_list))
  command.push("/usr/pgsql-9.5/bin/postgresql95-setup initdb")
  command.push(command.start_service("postgresql-9.5"))
else
  lv.require_apt_repo("postgresql9.5")
  package_list = ["postgresql-9.5", "php5.6-pgsql"]
  lv.push_install_message(["Postgresql 9.5 For PHP 5.6"])
  lv.push_install_message(package_list, 1)
  command.push(command.install(package_list, "-qq --allow-unauthenticated"))
end
