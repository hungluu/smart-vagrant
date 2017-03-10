#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
command = LampVagrant.command
# Hide tty warning
command.push("sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile")
command.push_message("=====================================")
command.push_message("WELCOME TO %s <Provisioner>", ["Lamp-Vagrant"])
command.push_message("=====================================")
command.push_message("* Checking dependencies ...")
#=====================================
# Start editing from here
