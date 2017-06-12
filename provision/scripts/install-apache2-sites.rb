lv = SmartVagrant::SmartVagrant.instance
command = lv.command
sites = lv.settings["sites"]
apache2_site_folder = "/etc/" + command.resolve_packages("apache2") + "/sites-enabled/"

command.push(command.remove(apache2_site_folder))
command.push(command.create_folder(apache2_site_folder))
unless sites.nil?
  sites.each do |site_name|
    command.push_message("[apache2] Enabling site '#{site_name}' ...")
    Apache2.enable_site(site_name)
  end
end
if lv.settings["use_ultilities"] === true
  command.push(command.copy("/smart-vagrant/config/ultilities/smart-vagrant-ultilities.conf", "#{apache2_site_folder}smart-vagrant-ultilities.conf"))
end

if lv.os === "centos"
  command.push(command.sudo("setenforce 0"))
end
Apache2.restart
