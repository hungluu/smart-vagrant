#======================================
# Smart-Vagrant
# @copyright : Hung Luu (c) 2017
#======================================
lv = SmartVagrant.instance
command = lv.command
# Hide tty warning
first_commands = [
  command.echo("====================================="),
  command.echo("WELCOME TO %s <Provisioner>", ["Smart-Vagrant"]),
  command.echo("====================================="),
  command.echo("* Checking dependencies ...")
]

case lv.os
when "centos"
  first_commands.insert(0, command.sudo("setenforce 0"))
else
  # Ubuntu
  first_commands.insert(0, command.sudo("sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"))
end

command.push(command.join_commands(first_commands), false)
#=====================================
# Start editing from here
