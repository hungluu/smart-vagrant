#======================================
# Sweet-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
lv = SweetVagrant.instance
command = lv.command
# Ensure postgresql 9.5 installable
command.push_message("Adding apt-repo for postgresql 9.5 ...")
case lv.os
when "centos"
  case lv.version
  when "7"
    command.push(command.add_repo("http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm"))
  else
    puts "[Error] This version of centos has no supports for Postgresql 9.5."
  end
else
  lv.queue_copy("etc/apt/sources.list.d/pgdg.list")
end
