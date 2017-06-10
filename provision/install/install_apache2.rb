#======================================
# Sweet-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
# Install Apache 2
lv = SweetVagrant.instance
command = lv.command
lv.push_install_message(["Apache 2"])
command.push(command.install(["apache2"]))
case lv.os
when "centos"
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/sweet-vagrant/config/apache2/sweet-vagrant.conf", "/etc/httpd/conf.d/sweet-vagrant.conf"))
else
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/sweet-vagrant/config/apache2/sweet-vagrant.conf", "/etc/apache2/conf-available/sweet-vagrant.conf"))
  command.push("a2enconf sweet-vagrant >/dev/null 2>/dev/null")
  command.push("a2enmod rewrite >/dev/null 2>/dev/null")
end
