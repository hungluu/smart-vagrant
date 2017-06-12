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


#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
require_relative "Base"
module SmartVagrantPackage
  class Php < Base
    def name
      "PHP " + config["php_version"].to_s
    end

    def package
      postgre = "postgresql-" + config["postgresql_version"].to_s
      case os
      when "centos"
        postgre = postgre.gsub(/postgresql\-9\.5/, 'postgresql95')
      end

      postgre
    end

    # install apache2
    def install
      smart.require_apt_repo("php")

      postgre = package
      php = require("php").package

      case os
      when "centos"
        package_list = ["postgresql95-server", "postgresql95", "php5.6-pgsql"]
        smart.push_install_message(package_list, 1);
        acquire_list(package_list)
      when "ubuntu"
        package_list = ["postgresql95-server", "postgresql95", "php5.6-pgsql"]
        smart.push_install_message(package_list, 1);
        acquire_list(package_list)
      else
        command.push_message("No supported php for this OS")
      end
    end
  end
end
