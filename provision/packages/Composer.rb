#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
require_relative "Base"
module SmartVagrantPackage
  class Composer < Base
    def name
      "Composer"
    end

    # install apache2
    def install
      require("php")

      case os
      when "centos"
        command.push_message("No support yet.");
      else
        command.push("curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer 2>/dev/null 1>/dev/null");
      end
    end
  end
end
