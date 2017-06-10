#======================================
# Smart-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
# Install Apache 2
lv = SmartVagrant.instance
command = lv.command
lv.push_install_message(["Apache 2"])
command.push(command.install(["apache2"]))
case lv.os
when "centos"
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/smart-vagrant/config/apache2/smart-vagrant.conf", "/etc/httpd/conf.d/smart-vagrant.conf"))
else
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/smart-vagrant/config/apache2/smart-vagrant.conf", "/etc/apache2/conf-available/smart-vagrant.conf"))
  command.push("a2enconf smart-vagrant >/dev/null 2>/dev/null")
  command.push("a2enmod rewrite >/dev/null 2>/dev/null")
end
