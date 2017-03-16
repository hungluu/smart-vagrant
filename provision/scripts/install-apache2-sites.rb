lv = LampVagrant.instance
command = lv.command
sites = lv.settings["sites"]
case lv.os
when "centos"
  command.push(command.remove("/etc/httpd/sites-enabled/"))
  command.push(command.create_folder("/etc/httpd/sites-enabled/"))
  unless sites.nil?
    sites.each do |site_name|
      command.push_message(" * Installing site '#{site_name}'")
      command.push(command.copy("/lamp-vagrant/config/apache2/sites/#{site_name}.conf", "/etc/httpd/sites-enabled/#{site_name}.conf"))
    end
  end
  if lv.settings["use_ultilities"] === true
    command.push(command.copy("/lamp-vagrant/config/ultilities/lamp-vagrant-ultilities.conf", "/etc/httpd/sites-enabled/lamp-vagrant-ultilities.conf"))
  end
else
  command.push(command.remove("/etc/apache2/sites-enabled/"))
  command.push(command.create_folder("/etc/apache2/sites-enabled/"))
  unless sites.nil?
    sites.each do |site_name|
      command.push_message(" * Installing site '#{site_name}'")
      command.push(command.copy("/lamp-vagrant/config/apache2/sites/#{site_name}.conf", "/etc/apache2/sites-enabled/#{site_name}.conf"))
    end
  end
  if lv.settings["use_ultilities"] === true
    command.push(command.copy("/lamp-vagrant/config/ultilities/lamp-vagrant-ultilities.conf", "/etc/apache2/sites-enabled/lamp-vagrant-ultilities.conf"))
  end
end
command.push(command.sudo("setenforce 0"))
lv.apache2_restart
