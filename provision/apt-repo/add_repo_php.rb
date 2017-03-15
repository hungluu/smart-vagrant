#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
command = lv.command
command.push_message("Adding apt-repo for PHP ...")
command.push(command.add_repo("ppa:ondrej/php"))
