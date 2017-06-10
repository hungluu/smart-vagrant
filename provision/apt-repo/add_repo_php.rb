#======================================
# Sweet-Vagrant
# @author : HR
# @copyright : Hung Luu (c) 2017
#======================================
lv = SweetVagrant.instance
command = lv.command
command.push_message("Adding apt-repo for PHP ...")
case lv.os
when "centos"
  if lv.version === "7"
    command.push(command.add_repo("https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"))
    command.push(command.add_repo("https://mirror.webtatic.com/yum/el7/webtatic-release.rpm"))
  end
else
  command.push(command.add_repo("ppa:ondrej/php"))
end
