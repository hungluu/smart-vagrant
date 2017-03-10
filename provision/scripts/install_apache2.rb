#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install Apache 2
command = LVCommand.shared_command
command.push_install(["apache2"])
# Custome apache2 config and hide ServerName warning
command.push(command.copy("/vagrant/config/apache2/lamp-vagrant.conf", "/etc/apache2/conf-available/lamp-vagrant.conf"))
command.push("a2enconf lamp-vagrant 2>/dev/null")
