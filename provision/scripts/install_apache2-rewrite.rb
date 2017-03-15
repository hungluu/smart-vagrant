#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
# Enable mod rewrite
command = LampVagrant.instance
command.push_message("Enabling mod_rewrite for apache2 ...")
command.push("a2enmod rewrite")
