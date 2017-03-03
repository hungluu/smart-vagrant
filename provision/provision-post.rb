command = LVCommand.shared_command
command.push_message("* End checking dependencies ...")
command.push_message("* Removing unused packages ...")
command.push_message(command.clean_up)
command.push(command.restart_service("apache2"))
#=====================================
# Start editing from here
