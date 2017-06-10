require_relative "BaseServiceCommand"

class Apache2 < BaseServiceCommand
  def self.restart
    command.push(command.restart_service("apache2"))
  end

  def self.start
    command.push(command.start_service("apache2"))
  end

  def self.stop
    command.push(command.stop_service("apache2"))
  end

  def self.enable_mod(mod_name)
  end

  def self.enable_site(site_name)
    apache2_folder = command.resolve_packages("apache2")
    command.push(command.copy("/sweet-vagrant/config/apache2/sites/#{site_name}.conf", "/etc/#{apache2_folder}/sites-enabled/#{site_name}.conf"))
  end
end
