lv = SweetVagrant.instance
command = lv.command
command.push_message("* End checking dependencies ...")
command.push_message("* Removing unused packages ...")
command.push(command.clean_up)
#=====================================
# Start editing from here
#=====================================
