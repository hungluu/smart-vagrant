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
      php = "php" + config["php_version"].to_s
      case os
      when "centos"
        php = php.gsub(/php5\.6/, 'php56w')
      end

      php
    end

    # install apache2
    def install
      smart.require_apt_repo("php")

      php = package

      package_list = ["python-software-properties", php, "libapache2-mod-" + php, php + "-opcache", php + "-mcrypt", php + "-mbstring", php + "-pdo"]
      smart.push_install_message(package_list, 1);
      acquire_list(package_list)

      case os
      when "centos"
        return
      when "ubuntu"
        # Applying new php version to apache2
        command.push_message("Apply PHP 5.6 to Apache2 ...")
        command.push("a2dismod php5 2>dev>null")
        command.push("a2dismod php7 2>dev>null")
        command.push("a2enmod php5.6 2>dev>null")
      else
        command.push_message("No supported php for this OS")
      end
    end
  end
end
