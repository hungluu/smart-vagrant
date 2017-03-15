#======================================
# Lamp-Vagrant
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
command = lv.command
# Hide tty warning
command.push(command.join_commands([
  command.sudo("sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"),
  command.echo("====================================="),
  command.echo("WELCOME TO %s <Provisioner>", ["Lamp-Vagrant"]),
  command.echo("====================================="),
  command.echo("* Checking dependencies ...")
]), false)
#=====================================
# Start editing from here
