#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
require_relative "Base"
module SmartVagrantPackage
  class Apache2 < Base
    def name
      "Apache 2"
    end

    def package
      case os
      when "centos"
        "httpd"
      else
        "apache2"
      end
    end

    # install apache2
    def install
      acquire(package)

      case os
      when "centos"
        # Custome apache2 config and hide ServerName warning
        command.push(command.copy("/smart-vagrant/config/apache2/smart-vagrant.conf", "/etc/httpd/conf.d/smart-vagrant.conf"))
      else
        # Custome apache2 config and hide ServerName warning
        command.push(command.copy("/smart-vagrant/config/apache2/smart-vagrant.conf", "/etc/apache2/conf-available/smart-vagrant.conf"))
        command.push("a2enconf smart-vagrant >/dev/null 2>/dev/null")
        command.push("a2enmod rewrite >/dev/null 2>/dev/null")
      end
    end
  end
end
