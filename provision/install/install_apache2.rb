#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install Apache 2
lv = LampVagrant.instance
command = lv.command
lv.push_install_message(["Apache 2"])

case lv.os
when "centos"
  command.push(command.install(["httpd"]))
  # load sites-enabled conf
  command.push(command.join_commands([
      command.join_commands(["grep", command.quote("IncludeOptional sites-enabled"),  command.quote("/etc/httpd/conf/httpd.conf"), "1>/dev/null"], " "),
      "echo 'IncludeOptional sites-enabled/*.conf' | sudo tee -a '/etc/httpd/conf/httpd.conf'"
    ], "||"), false)
else
  command.push(command.install(["apache2"]))
  # Custome apache2 config and hide ServerName warning
  command.push(command.copy("/lamp-vagrant/config/apache2/lamp-vagrant.conf", "/etc/apache2/conf-available/lamp-vagrant.conf"))
  command.push("a2enconf lamp-vagrant 2>/dev/null")
end
