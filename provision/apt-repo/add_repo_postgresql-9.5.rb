#======================================
# Lamp-Vagrant
# @author : HR
# @copyright : Dumday (c) 2017
#======================================
lv = LampVagrant.instance
command = lv.command
# Ensure postgresql 9.5 installable
command.push_message("Adding apt-repo for postgresql 9.5 ...")
lv.queue_copy("etc/apt/sources.list.d/pgdg.list")
