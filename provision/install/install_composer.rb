#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install Composer
lv = LampVagrant.instance
command = lv.command

lv.require_package('php5.6')
lv.push_install_message(["Composer"])
case lv.os
when "centos"
  # Custome apache2 config and hide ServerName warning
  command.push_message("No support yet.");
else
  # Custome apache2 config and hide ServerName warning
  command.push("curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer 2>/dev/null 1>/dev/null");
end
