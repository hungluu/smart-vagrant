#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
require_relative "Base"
module SmartVagrant
  module Packages
    class Php < Base
      # package display name
      def name
        "PHP " + version
      end

      # init package
      def init
        # get config version
        set_version(config["package_version"]["php"].to_s)
      end

      # resolve package
      def package
        php = "php" + version
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
        acquire_list(package_list)

        case os
        when "centos"
          # Success
        when "ubuntu"
          # Applying new php version to apache2
          command.push_message("Appling " + name + " to Apache2 ...")
          command.push("a2dismod php5 2>dev>null")
          command.push("a2dismod php7 2>dev>null")
          command.push("a2enmod php5.6 2>dev>null")
          # Success
        else
          command.push_message("No supported php for this OS")
        end
      end
    end
  end
end
