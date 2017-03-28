#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install Apache 2
lv = LampVagrant.instance
command = lv.command
lv.push_install_message(["Apache 2"])
command.push(command.install(["apache2"]))
case lv.os
when "centos"
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/lamp-vagrant/config/apache2/lamp-vagrant.conf", "/etc/httpd/conf.d/lamp-vagrant.conf"))
else
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/lamp-vagrant/config/apache2/lamp-vagrant.conf", "/etc/apache2/conf-available/lamp-vagrant.conf"))
  command.push("a2enconf lamp-vagrant >/dev/null 2>/dev/null")
  command.push("a2enmod rewrite >/dev/null 2>/dev/null")
end
