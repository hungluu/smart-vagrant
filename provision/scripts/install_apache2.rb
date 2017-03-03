#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Install Apache 2
command = LVCommand.shared_command
command.push_install(["apache2"])
# Custome apache2 config and hide ServerName warning
command.push(command.copy("/vagrant/config/apache2/lampVagrant.conf", "/etc/apache2/conf-available/lampVagrant.conf"))
command.push("a2enconf lampVagrant 2>/dev/null")
