#======================================
# Smart-Vagrant
# @copyright : Hung Luu (c) 2017
#======================================
lv = SmartVagrant::SmartVagrant.instance
command = lv.command
lv.push_install_message(["Xdebug for PHP 5.6"])
# Ensure xdebug directory exists
command.push(command.create_folder("/usr/lib/php5/20131226"))
# Copy a file from config/copy folder
lv.queue_copy("usr/lib/php5/20131226/xdebug.so")
case lv.os
when "centos"
  # Copy to custom directory
  lv.queue_copy("etc/php/5.6/apache2/php.ini", "etc/php.ini")
else
  lv.queue_copy("etc/php/5.6/apache2/php.ini")
end
