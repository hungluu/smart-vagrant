#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
# provision/install/install_php5.6-postgre9.5.rb
# Installing postgresql 9.5 for php 5.6
lv = SmartVagrant::SmartVagrant.instance
command = lv.command
# require apt repo for postgresql 9.5
lv.require_apt_repo("postgre9.5")
case lv.os
# for machine with os CENTOS
when "centos"
  # packages that we will install for our server to work
  package_list = ["postgresql95-server", "postgresql95", "php5.6-pgsql"]
  # show message "Installing <package> ..."
  lv.push_install_message(["Postgresql 9.5 For PHP 5.6"])
  lv.push_install_message(package_list, 1)
  # Install the packages we need
  command.push(command.install(package_list))
  # Run a command
  command.push("/usr/pgsql-9.5/bin/postgresql95-setup initdb")
  # command.start_service will generate a command that start the service, in this example is postgresql-9.5
  command.push(command.start_service("postgresql-9.5"))
else
  package_list = ["postgresql-9.5", "php5.6-pgsql"]
  lv.push_install_message(["Postgresql 9.5 For PHP 5.6"])
  lv.push_install_message(package_list, 1)
  # Install the packages we need with custom options
  # These options allow unauthenticated packages to be installed
  command.push(command.install(package_list, "-qq --allow-unauthenticated"))
end
